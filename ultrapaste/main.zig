const std = @import("std");
const Allocator = std.mem.Allocator;
const Io = std.Io;

const Regex = @import("regex").Regex;

const TypeTool = enum {
    wtype,
};

const ClipboardTool = enum {
    wl_clipboard,
};

const Actions = std.ArrayList([]const u8);

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

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
        std.log.debug("Ticket: {s}", .{ticket_number});
        try appendTicketActions(gpa, &actions, ticket_number);
    }

    if (try parsePrNumber(gpa, text)) |pr_number| {
        std.log.debug("PR: {s}", .{pr_number});
        try appendPrActions(gpa, &actions, pr_number);
    }

    if (actions.items.len > 0) {
        if (try prompt(gpa, io, &actions)) |selected| {
            defer gpa.free(selected);
            if (std.mem.find(u8, selected, ": ")) |index| {
                try typeText(io, std.mem.trimEnd(u8, selected[index + 2 ..], "\n"));
            }
        }
    }
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

fn typeText(io: Io, text: []const u8) !void {
    const argv = [_][]const u8{ "ydotool", "type", "--key-delay=0", "--file=-" };
    var child = try std.process.spawn(io, .{ .argv = &argv, .stdin = .pipe });

    var stdin_buffer: [4096]u8 = undefined;
    var stdin_writer = child.stdin.?.writer(io, &stdin_buffer);
    var stdin = &stdin_writer.interface;

    try stdin.writeAll(text);
    try stdin.flush();
    child.stdin.?.close(io);
    child.stdin = null;

    const term = try child.wait(io);
    switch (term) {
        .exited => |code| if (code == 0) return,
        else => {},
    }
    std.log.warn("ydotool exited {}", .{term});
    return error.ProcessFailed;
}
