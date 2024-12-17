const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const testing = std.testing;

pub fn main() !void {
    std.debug.print("Star1: {d}\n", .{try star1("src/day9/input.txt")});
    std.debug.print("Star2: {d}\n", .{try star2("src/day9/input.txt")});
}

fn star1(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(content);

    const disk_layout = try parse(allocator, content);
    defer allocator.free(disk_layout);

    compact(disk_layout);

    return checksum(disk_layout);
}

fn star2(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(content);

    const disk_layout = try parse(allocator, content);
    defer allocator.free(disk_layout);

    compactNoFrag(disk_layout);

    return checksum(disk_layout);
}

fn parse(allocator: Allocator, input: []const u8) ![]?u32 {
    var memory = ArrayList(?u32).init(allocator);
    defer memory.deinit();

    var iter = std.mem.window(u8, input, 2, 2);
    var file_id: u32 = 0;
    while (iter.next()) |window| {
        const file_size = window[0] - '0';
        try memory.appendNTimes(file_id, file_size);
        file_id += 1;

        if (window.len == 1 or window[1] == '\n') {
            break;
        }
        const free_space_size = window[1] - '0';
        try memory.appendNTimes(null, free_space_size);
    }

    return memory.toOwnedSlice();
}

fn compact(layout: []?u32) void {
    var file_idx = layout.len - 1;
    var free_space_idx: usize = 0;
    while (free_space_idx < file_idx) {
        if (layout[free_space_idx]) |_| {
            free_space_idx += 1;
            continue;
        }
        if (layout[file_idx] == null) {
            file_idx -= 1;
            continue;
        }
        // swap the two values
        const tmp = layout[free_space_idx];
        layout[free_space_idx] = layout[file_idx];
        layout[file_idx] = tmp;
        free_space_idx += 1;
        file_idx -= 1;
    }
}

fn compactNoFrag(layout: []?u32) void {
    var file_idx = layout.len - 1;
    outer: while (true) {
        if (layout[file_idx] == 0) {
            break;
        }

        while (layout[file_idx] == null) {
            file_idx -= 1;
            if (file_idx < 0) {
                break :outer;
            }
        }

        var file_size: usize = 0;
        while (layout[file_idx - file_size] == layout[file_idx]) {
            if (file_idx - file_size == 0) {
                break;
            }
            file_size += 1;
        }
        compactFile(layout, file_idx, file_size);
        file_idx -= file_size;
    }
}

fn compactFile(layout: []?u32, file_idx: usize, file_size: usize) void {
    var free_space_idx: usize = 0;
    outer: while (true) {
        while (layout[free_space_idx]) |_| {
            free_space_idx += 1;
            if (free_space_idx == layout.len) {
                break :outer;
            }
        }

        // compute slot size
        var free_space_size: usize = 0;
        while (layout[free_space_idx + free_space_size] == null) {
            free_space_size += 1;
            if (free_space_idx + free_space_size == layout.len) {
                break;
            }
        }

        if (free_space_idx >= file_idx) {
            break;
        }

        // tries to swap the two values
        if (free_space_size < file_size) {
            free_space_idx += free_space_size;
            continue;
        }
        var file_pos = file_idx;
        for (0..file_size) |_| {
            layout[free_space_idx] = layout[file_pos];
            layout[file_pos] = null;
            file_pos -= 1;
            free_space_idx += 1;
        }
        break;
    }
}

fn checksum(layout: []const ?u32) usize {
    var sum: usize = 0;
    for (layout, 0..) |v, i| {
        sum += @as(usize, @intCast(v orelse 0)) * i;
    }
    return sum;
}

test "star1" {
    try testing.expectEqual(1928, star1("src/day9/test.txt"));
}

test "parse" {
    const allocator = std.testing.allocator;
    const input = "12345";
    const expected = [_]?u32{ 0, null, null, 1, 1, 1, null, null, null, null, 2, 2, 2, 2, 2 };
    const result = try parse(allocator, input);
    defer allocator.free(result);

    try testing.expectEqual(expected.len, result.len);

    for (result, expected) |v, e| {
        try testing.expectEqual(e, v);
    }
}

test "compact" {
    var input = [_]?u32{ 0, null, null, 1, 1, 1, null, null, null, null, 2, 2, 2, 2, 2 };
    const expected = [_]?u32{ 0, 2, 2, 1, 1, 1, 2, 2, 2, null, null, null, null, null, null };
    compact(&input);

    try testing.expect(std.mem.eql(?u32, &input, &expected));
}

test "compactNoFrag" {
    var input = [_]?u32{ 0, null, null, 1, 1, 1, null, null, null, null, 2, 2, 2 };
    const expected = [_]?u32{ 0, null, null, 1, 1, 1, 2, 2, 2, null, null, null, null };
    compactNoFrag(&input);

    try testing.expect(std.mem.eql(?u32, &input, &expected));
}

test "checksum" {
    const input = [_]?u32{ 0, 2, 2, 1, 1, 1, 2, 2, 2, null, null, null, null, null, null };
    try testing.expectEqual(60, checksum(&input));
}

test "star2" {
    try testing.expectEqual(2858, star2("src/day9/test.txt"));
}
