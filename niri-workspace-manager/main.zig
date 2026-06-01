const std = @import("std");
const Allocator = std.mem.Allocator;
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    std.log.info("Hi!", .{});

    const niri_argv: [4][]const u8 = .{ "niri", "msg", "--json", "event-stream" };
    var niri_child = try std.process.spawn(io, .{
        .argv = &niri_argv,
        .stdout = .pipe,
    });
    var stdout_buffer: [std.math.pow(usize, 2, 16)]u8 = undefined;
    var stdout_reader = niri_child.stdout.?.reader(io, &stdout_buffer);
    var stdout = &stdout_reader.interface;

    while (true) {
        const slice = try stdout.takeDelimiter('\n');
        if (slice) |s| {
            if (try getActiveWindowTitle(gpa, s)) |title| {
                std.log.debug("Found title: {s}", .{title});
                if (extractPrefix(title)) |prefix| {
                    switch (prefix) {
                        .prefix => |p| {
                            std.log.debug("Found prefix: {s}", .{p});
                            try setWorkspaceName(io, p);
                        },
                        .empty => try unsetWorkspaceName(io),
                    }
                }
            } else {
                std.log.debug("Ignoring event: {s}", .{s});
                continue;
            }
        } else {
            std.log.warn("no slice", .{});
        }
    }
}

fn getActiveWindowTitle(gpa: Allocator, data: []const u8) !?[]const u8 {
    const message = std.json.parseFromSlice(_WindowOpenedOrChanged, gpa, data, .{
        .allocate = .alloc_if_needed,
        .ignore_unknown_fields = true,
    }) catch |err| switch (err) {
        error.MissingField => return null,
        else => |e| return e,
    };
    defer message.deinit();
    if (!message.value.WindowOpenedOrChanged.window.is_focused) return null;
    return message.value.WindowOpenedOrChanged.window.title;
}

const _WindowOpenedOrChanged = struct {
    WindowOpenedOrChanged: struct {
        window: struct {
            title: []const u8,
            is_focused: bool,
        },
    },
};

const Prefix = union(enum) {
    empty,
    prefix: []const u8,
};

fn extractPrefix(s: []const u8) ?Prefix {
    if (s.len >= 3 and s[0] == '[') {
        if (std.mem.findScalarPos(u8, s, 1, ']')) |end| {
            const prefix = s[1..end];
            if (prefix.len > 0 and std.mem.trimEnd(u8, prefix, "0123456789").len > 0) {
                return .{ .prefix = prefix };
            } else {
                return .empty;
            }
        }
    }
    return null;
}

fn setWorkspaceName(io: Io, name: []const u8) !void {
    const argv: [5][]const u8 = .{
        "niri",
        "msg",
        "action",
        "set-workspace-name",
        name,
    };
    var child = try std.process.spawn(io, .{ .argv = &argv });
    const term = try child.wait(io);
    switch (term) {
        .exited => |code| if (code == 0) return,
        else => {},
    }
    std.log.warn("set-workspace-name failed: {any}", .{term});
}

fn unsetWorkspaceName(io: Io) !void {
    const argv: [4][]const u8 = .{
        "niri",
        "msg",
        "action",
        "unset-workspace-name",
    };
    var child = try std.process.spawn(io, .{ .argv = &argv });
    const term = try child.wait(io);
    switch (term) {
        .exited => |code| if (code == 0) return,
        else => {},
    }
    std.log.warn("unset-workspace-name failed: {any}", .{term});
}
