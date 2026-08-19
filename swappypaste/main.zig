const std = @import("std");
const Allocator = std.mem.Allocator;
const Io = std.Io;

const Regex = @import("regex").Regex;

const Mode = enum {
    offer,
    swap,
};

const ClipboardTool = enum {
    wl_clipboard,
};

const ExtraModifiers = enum {
    none,
    shift,
};

const TypeTool = enum {
    wtype,
};

const Actions = std.ArrayList([]const u8);

fn printHelp(io: Io, file: std.Io.File) !void {
    var buffer: [4096]u8 = undefined;
    var file_writer: std.Io.File.Writer = .init(file, io, &buffer);
    var writer = &file_writer.interface;

    try writer.writeAll(
        \\usage: swappypaste MODE [--shift]
        \\
        \\Modes:
        \\  offer     Offer to paste variations of the current clipboard data
        \\  swap      Swap the selected text with the clipboard contents
        \\
        \\Options:
        \\  --shift   Use Shift when typing Ctrl+C and Ctrl+V (for terminals)
        \\
    );
    try writer.flush();
}

var clipboard_tool: ClipboardTool = undefined;
var extra_modifiers: ExtraModifiers = .none;
var type_tool: TypeTool = undefined;

pub fn main(init: std.process.Init) !u8 {
    const gpa = init.gpa;
    const io = init.io;

    var args = try init.minimal.args.iterateAllocator(gpa);
    defer args.deinit();

    var mode: ?Mode = null;
    _ = args.next();
    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--help")) {
            try printHelp(io, .stdout());
            return 0;
        } else if (mode == null and std.mem.eql(u8, arg, "offer")) {
            mode = .offer;
        } else if (mode == null and std.mem.eql(u8, arg, "swap")) {
            mode = .swap;
        } else if (std.mem.eql(u8, arg, "--shift")) {
            extra_modifiers = .shift;
        } else {
            std.log.err("Unrecognized argument: {s}", .{arg});
            return 2;
        }
    }

    clipboard_tool = try detectClipboardTool(io);
    std.log.info("Detected clipboard tool: {t}", .{clipboard_tool});

    type_tool = try detectTypeTool(io);
    std.log.info("Detected type tool: {t}", .{type_tool});

    if (mode) |m| switch (m) {
        .offer => try offer(gpa, io),
        .swap => try swap(gpa, io),
    } else {
        try printHelp(io, .stderr());
        return 2;
    }
    return 0;
}

fn offer(gpa: Allocator, io: Io) !void {
    const text = try readClipboard(gpa, io);
    defer gpa.free(text);
    std.log.debug("Text from clipboard: {s}", .{text});

    var actions: Actions = .empty;
    defer {
        for (actions.items) |i| {
            gpa.free(i);
        }
        actions.deinit(gpa);
    }

    if (try parseTicketNumber(gpa, text)) |ticket_number| {
        std.log.info("Detected ticket number: {s}", .{ticket_number});
        try appendTicketActions(gpa, &actions, ticket_number);
    }

    if (try parsePrNumber(gpa, text)) |pr_number| {
        std.log.info("Detected PR number: {s}", .{pr_number});
        try appendPrActions(gpa, &actions, pr_number);
    }

    if (actions.items.len > 0) {
        if (try prompt(gpa, io, &actions)) |selected| {
            defer gpa.free(selected);
            if (std.mem.find(u8, selected, ": ")) |index| {
                try paste(gpa, io, std.mem.trimEnd(u8, selected[index + 2 ..], "\n"));
            }
        }
    }
}

fn canSpawn(io: Io, argv: []const []const u8) !bool {
    _ = std.process.spawn(
        io,
        .{ .argv = argv, .stdout = .ignore },
    ) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => {
            std.log.warn("Got {t} while trying to spawn {s}", .{ err, argv[0] });
            return err;
        },
    };
    return true;
}

fn detectClipboardTool(io: Io) !ClipboardTool {
    if (try canSpawn(io, &.{ "wl-copy", "--help" })) return .wl_clipboard;
    return error.ClipboardToolNotFound;
}

fn detectTypeTool(io: Io) !TypeTool {
    if (try canSpawn(io, &.{ "wtype", "" })) return .wtype;
    return error.TypeToolNotFound;
}

fn parsePrNumber(gpa: Allocator, text: []const u8) !?[]const u8 {
    var regex = try Regex.compile(gpa, "\\d+");
    defer regex.deinit();

    if (try regex.find(text)) |match| {
        if (4 <= match.slice.len and match.slice.len < 7) {
            var mut_match = match;
            defer mut_match.deinit(gpa);
            return match.slice;
        }
    }
    return null;
}

fn appendPrActions(gpa: Allocator, actions: *Actions, pr: []const u8) !void {
    try actions.appendSlice(gpa, &[_][]const u8{
        try std.fmt.allocPrint(gpa, "PR link: [#{0s}](https://app.graphite.com/github/pr/braidlending/braid/{0s})", .{pr}),
        try std.fmt.allocPrint(gpa, "PR number: #{s}", .{pr}),
        try std.fmt.allocPrint(gpa, "PR url: https://app.graphite.com/github/pr/braidlending/braid/{s}", .{pr}),
    });
}

fn parseTicketNumber(gpa: Allocator, text: []const u8) !?[]const u8 {
    var regex = try Regex.compile(gpa, "[A-Z]{2,3}-\\d+");
    defer regex.deinit();

    if (try regex.find(text)) |match| {
        if (match.slice.len < 10) {
            var mut_match = match;
            defer mut_match.deinit(gpa);
            return match.slice;
        }
    }
    return null;
}

fn appendTicketActions(gpa: Allocator, actions: *Actions, ticket: []const u8) !void {
    // todo
    try actions.appendSlice(gpa, &[_][]const u8{
        try std.fmt.allocPrint(gpa, "Ticket link: [{0s}](https://linear.app/pylonlending/issue/{0s})", .{ticket}),
        try std.fmt.allocPrint(gpa, "Ticket number: {s}", .{ticket}),
        try std.fmt.allocPrint(gpa, "Ticket url: https://linear.app/pylonlending/issue/{s}", .{ticket}),
    });
}

fn readClipboard(gpa: Allocator, io: Io) ![]const u8 {
    const argv = [_][]const u8{ "wl-paste", "--type=text", "--no-newline" };
    var child = try std.process.spawn(io, .{ .argv = &argv, .stdout = .pipe });

    var buffer: [4096]u8 = undefined;
    var reader = child.stdout.?.reader(io, &buffer);
    var stdout = &reader.interface;

    const text = try stdout.allocRemaining(gpa, .unlimited);
    errdefer gpa.free(text);

    const term = try child.wait(io);
    switch (term) {
        .exited => |code| if (code == 0) return text,
        else => {},
    }
    std.log.warn("wl-paste exited {}", .{term});
    return error.ProcessFailed;
}

fn writeClipboard(io: Io, text: []const u8) !void {
    const argv = [_][]const u8{"wl-copy"};
    var child = try std.process.spawn(io, .{ .argv = &argv, .stdin = .pipe });

    var buffer: [4096]u8 = undefined;
    var reader = child.stdin.?.writer(io, &buffer);
    var stdin = &reader.interface;

    try stdin.writeAll(text);
    try stdin.flush();
    child.stdin.?.close(io);
    child.stdin = null;

    const term = try child.wait(io);
    switch (term) {
        .exited => |code| if (code == 0) return,
        else => {},
    }
    std.log.warn("wl-paste exited {}", .{term});
    return error.ProcessFailed;
}

fn prompt(gpa: Allocator, io: Io, actions: *Actions) !?[]const u8 {
    const argv = [_][]const u8{ "fuzzel", "--dmenu", "--minimal-lines" };
    var child = try std.process.spawn(io, .{ .argv = &argv, .stdin = .pipe, .stdout = .pipe });

    var stdin_buffer: [4096]u8 = undefined;
    var stdin_writer = child.stdin.?.writer(io, &stdin_buffer);
    var stdin = &stdin_writer.interface;

    var stdout_buffer: [4096]u8 = undefined;
    var stdout_reader = child.stdout.?.reader(io, &stdout_buffer);
    var stdout = &stdout_reader.interface;

    for (actions.items) |action| {
        try stdin.print("{s}\n", .{action});
    }
    try stdin.flush();
    child.stdin.?.close(io);
    child.stdin = null;

    const text = try stdout.allocRemaining(gpa, .unlimited);
    errdefer gpa.free(text);

    const term = try child.wait(io);
    switch (term) {
        .exited => |code| switch (code) {
            0 => return text,
            2 => return null,
            else => {},
        },
        else => {},
    }
    std.log.warn("fuzzel exited {}", .{term});
    return error.ProcessFailed;
}

fn swap(gpa: Allocator, io: Io) !void {
    const original_text = try readClipboard(gpa, io);
    defer gpa.free(original_text);
    std.log.debug("Text to be pasted: {s}", .{original_text});

    try triggerCopy(io);
    const new_text = try readClipboard(gpa, io);
    defer gpa.free(new_text);
    std.log.debug("Text just copied: {s}", .{new_text});

    try writeClipboard(io, original_text);
    try triggerPaste(io);
    try writeClipboard(io, new_text);
}

fn paste(gpa: Allocator, io: Io, text: []const u8) !void {
    const original_text = try readClipboard(gpa, io);
    defer gpa.free(original_text);

    try writeClipboard(io, text);
    try triggerPaste(io);
    try writeClipboard(io, original_text);
}

fn triggerCopy(io: Io) !void {
    switch (type_tool) {
        .wtype => {
            wtype(io, .{
                .ctrl = true,
                .shift = extra_modifiers == .shift,
            }, "c") catch |e| {
                std.log.warn("wtype failed: {t}", .{e});
                return error.PasteFailed;
            };
        },
    }
    try io.sleep(.fromMilliseconds(100), .real);
}

fn triggerPaste(io: Io) !void {
    switch (type_tool) {
        .wtype => {
            wtype(io, .{
                .ctrl = true,
                .shift = extra_modifiers == .shift,
            }, "v") catch |e| {
                std.log.warn("wtype failed: {t}", .{e});
                return error.PasteFailed;
            };
        },
    }
    try io.sleep(.fromMilliseconds(100), .real);
}

const Modifiers = struct {
    ctrl: bool = false,
    shift: bool = false,
};

fn wtype(io: Io, modifiers: Modifiers, key: []const u8) !void {
    const ARGV_MAX = 7;
    var argvbuf: [ARGV_MAX][]const u8 = undefined;
    var argv: std.ArrayListUnmanaged([]const u8) = .initBuffer(&argvbuf);

    argv.appendAssumeCapacity("wtype");
    if (modifiers.ctrl) argv.appendSliceAssumeCapacity(&.{ "-M", "ctrl" });
    if (modifiers.shift) argv.appendSliceAssumeCapacity(&.{ "-M", "shift" });
    argv.appendSliceAssumeCapacity(&.{ "-k", key });

    var child = try std.process.spawn(io, .{ .argv = argv.items });
    const term = try child.wait(io);
    switch (term) {
        .exited => |code| switch (code) {
            0 => return,
            else => return error.NonzeroExit,
        },
        else => return error.UnexpectedTermination,
    }
}
