const std = @import("std");
const testing = std.testing;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    std.debug.print("Star 1: {}\n", .{try star1("src/day4/input.txt")});
    std.debug.print("Star 2: {}\n", .{try star2("src/day4/input.txt")});
}

fn star1(path: []const u8) !i64 {
    const allocator = std.heap.page_allocator;

    const content = try read(allocator, path);
    defer allocator.free(content);

    var rows = ArrayList([]const u8).init(allocator);
    defer rows.deinit();

    var lines = std.mem.tokenizeScalar(u8, content, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        try rows.append(line);
    }
    const table = rows.items;
    std.debug.print("Test: {c}\n", .{table[2][2]});

    return countMatches("XMAS", table);
}

pub fn read(allocator: Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const result = try file.readToEndAlloc(allocator, 1014 * 1024);
    return result;
}

fn countMatches(value: []const u8, content: [][]const u8) i64 {
    var count: i64 = 0;
    for (content, 0..) |line, i| {
        for (line, 0..) |_, j| {
            count += countLocalMatches(value, content, @intCast(i), @intCast(j));
        }
    }
    return count;
}

fn countLocalMatches(value: []const u8, content: [][]const u8, x0: i64, y0: i64) i64 {
    const max_i: i64 = @intCast(content.len);
    const max_j: i64 = @intCast(content[0].len);

    var count: i64 = 0;

    // Same line, next 4 chars
    var x_array = [_]i64{ x0, x0 + 1, x0 + 2, x0 + 3 };
    var y_array = [_]i64{ y0, y0, y0, y0 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // Same line, preivous 4 chars
    x_array = [_]i64{ x0, x0 - 1, x0 - 2, x0 - 3 };
    y_array = [_]i64{ y0, y0, y0, y0 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // Same column, next 4 chars
    x_array = [_]i64{ x0, x0, x0, x0 };
    y_array = [_]i64{ y0, y0 + 1, y0 + 2, y0 + 3 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // Same column, previous 4 chars
    x_array = [_]i64{ x0, x0, x0, x0 };
    y_array = [_]i64{ y0, y0 - 1, y0 - 2, y0 - 3 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // Diagonal, right up
    x_array = [_]i64{ x0, x0 + 1, x0 + 2, x0 + 3 };
    y_array = [_]i64{ y0, y0 + 1, y0 + 2, y0 + 3 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // Diagonal, right down
    x_array = [_]i64{ x0, x0 - 1, x0 - 2, x0 - 3 };
    y_array = [_]i64{ y0, y0 - 1, y0 - 2, y0 - 3 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // Diagonal, left up
    x_array = [_]i64{ x0, x0 + 1, x0 + 2, x0 + 3 };
    y_array = [_]i64{ y0, y0 - 1, y0 - 2, y0 - 3 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // Diagonal, left down
    x_array = [_]i64{ x0, x0 - 1, x0 - 2, x0 - 3 };
    y_array = [_]i64{ y0, y0 + 1, y0 + 2, y0 + 3 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    return count;
}

fn checkMatch(value: []const u8, content: [][]const u8, i_array: []i64, j_array: []i64, i_max: i64, j_max: i64) bool {
    for (value, i_array, j_array) |c, i, j| {
        if (i < 0 or i >= i_max or j < 0 or j >= j_max) {
            return false;
        }
        if (content[@intCast(i)][@intCast(j)] != c) {
            return false;
        }
    }
    return true;
}

fn star2(path: []const u8) !i64 {
    const allocator = std.heap.page_allocator;

    const content = try read(allocator, path);
    defer allocator.free(content);

    var rows = ArrayList([]const u8).init(allocator);
    defer rows.deinit();

    var lines = std.mem.tokenizeScalar(u8, content, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        try rows.append(line);
    }
    const table = rows.items;

    return countXMatches("MASMAS", table);
}

fn countXMatches(value: []const u8, content: [][]const u8) i64 {
    var count: i64 = 0;
    for (content, 0..) |line, i| {
        for (line, 0..) |_, j| {
            count += countLocalXMatches(value, content, @intCast(i), @intCast(j));
        }
    }
    return count;
}

fn countLocalXMatches(value: []const u8, content: [][]const u8, x0: i64, y0: i64) i64 {
    const max_i: i64 = @intCast(content.len);
    const max_j: i64 = @intCast(content[0].len);

    var count: i64 = 0;

    // top-left to bottom-right, bottom-left to top-right
    var x_array = [_]i64{ x0 - 1, x0, x0 + 1, x0 - 1, x0, x0 + 1 };
    var y_array = [_]i64{ y0 + 1, y0, y0 - 1, y0 - 1, y0, y0 + 1 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // top-left to bottom-right, top-right to bottom-left
    x_array = [_]i64{ x0 - 1, x0, x0 + 1, x0 + 1, x0, x0 - 1 };
    y_array = [_]i64{ y0 + 1, y0, y0 - 1, y0 + 1, y0, y0 - 1 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // bottom-right to top-left, top-right to bottom-left
    x_array = [_]i64{ x0 + 1, x0, x0 - 1, x0 + 1, x0, x0 - 1 };
    y_array = [_]i64{ y0 - 1, y0, y0 + 1, y0 + 1, y0, y0 - 1 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    // bottom-right to top-left, bottom-left to top-right
    x_array = [_]i64{ x0 + 1, x0, x0 - 1, x0 - 1, x0, x0 + 1 };
    y_array = [_]i64{ y0 - 1, y0, y0 + 1, y0 - 1, y0, y0 + 1 };
    if (checkMatch(value, content, &x_array, &y_array, max_i, max_j)) {
        count += 1;
    }

    return count;
}

test "Star 1" {
    try testing.expectEqual(18, try star1("src/day4/test.txt"));
}

test "Star 2" {
    try testing.expectEqual(9, try star2("src/day4/test.txt"));
}
