const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;

pub fn main() !void {
    std.debug.print("Star 1: {d}\n", .{try star1("src/day10/input.txt")});
    std.debug.print("Star 2: {d}\n", .{try star2("src/day10/input.txt")});
}

fn star1(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 4 * 1024);
    defer allocator.free(content);

    const table = try parse(allocator, content);
    defer {
        for (table) |row| {
            allocator.free(row);
        }
        allocator.free(table);
    }

    var total: usize = 0;
    for (table, 0..) |row, y| {
        for (row, 0..) |v, x| {
            if (v == 0) {
                total += try countReachablePeaks(allocator, table, x, y);
            }
        }
    }

    return total;
}

fn star2(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 4 * 1024);
    defer allocator.free(content);

    const table = try parse(allocator, content);
    defer {
        for (table) |row| {
            allocator.free(row);
        }
        allocator.free(table);
    }

    var total: usize = 0;
    for (table, 0..) |row, y| {
        for (row, 0..) |v, x| {
            if (v == 0) {
                total += trailRating(table, x, y);
            }
        }
    }

    return total;
}

fn parse(allocator: Allocator, input: []const u8) ![][]u8 {
    var table = ArrayList([]u8).init(allocator);

    var iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (iter.next()) |line| {
        var s = try allocator.alloc(u8, line.len);
        for (line, 0..) |c, i| {
            s[i] = c - '0';
        }
        try table.append(s);
    }

    return table.toOwnedSlice();
}

const PeakMap = AutoHashMap([2]usize, void);

fn countReachablePeaks(allocator: Allocator, table: [][]u8, x: usize, y: usize) !usize {
    var uniquePeaks = PeakMap.init(allocator);
    defer uniquePeaks.deinit();

    try exploreReachablePeaks(table, x, y, &uniquePeaks);
    return uniquePeaks.count();
}

fn exploreReachablePeaks(table: [][]u8, x: usize, y: usize, results: *PeakMap) !void {
    const value = table[y][x];
    const max_x = table[0].len;
    const max_y = table.len;

    if (value == 9) {
        try results.put(.{ x, y }, {});
        return;
    }

    const directions = [_][2]i8{
        [2]i8{ 1, 0 },
        [2]i8{ -1, 0 },
        [2]i8{ 0, 1 },
        [2]i8{ 0, -1 },
    };

    for (directions) |dir| {
        const new_x: i8 = @as(i8, @intCast(x)) + dir[0];
        if (new_x < 0 or new_x >= max_x) {
            continue;
        }

        const new_y: i8 = @as(i8, @intCast(y)) + dir[1];
        if (new_y < 0 or new_y >= max_y) {
            continue;
        }

        if (table[@intCast(new_y)][@intCast(new_x)] == value + 1) {
            try exploreReachablePeaks(table, @intCast(new_x), @intCast(new_y), results);
        }
    }

    return;
}

fn trailRating(table: [][]u8, x: usize, y: usize) usize {
    const value = table[y][x];
    const max_x = table[0].len;
    const max_y = table.len;

    if (value == 9) {
        return 1;
    }

    const directions = [_][2]i8{
        [2]i8{ 1, 0 },
        [2]i8{ -1, 0 },
        [2]i8{ 0, 1 },
        [2]i8{ 0, -1 },
    };

    var count: usize = 0;

    for (directions) |dir| {
        const new_x: i8 = @as(i8, @intCast(x)) + dir[0];
        if (new_x < 0 or new_x >= max_x) {
            continue;
        }

        const new_y: i8 = @as(i8, @intCast(y)) + dir[1];
        if (new_y < 0 or new_y >= max_y) {
            continue;
        }

        if (table[@intCast(new_y)][@intCast(new_x)] == value + 1) {
            count += trailRating(table, @intCast(new_x), @intCast(new_y));
        }
    }

    return count;
}

test "star1" {
    const result = try star1("src/day10/test.txt");
    try testing.expectEqual(36, result);
}

test "countReachablePeak" {
    const allocator = std.testing.allocator;
    const t = @embedFile("test.txt");
    const table = try parse(allocator, t);
    defer {
        for (table) |row| {
            allocator.free(row);
        }
        allocator.free(table);
    }

    try testing.expectEqual(5, countReachablePeaks(allocator, table, 2, 0));
    try testing.expectEqual(6, countReachablePeaks(allocator, table, 4, 0));
    try testing.expectEqual(5, countReachablePeaks(allocator, table, 4, 2));
    try testing.expectEqual(3, countReachablePeaks(allocator, table, 6, 4));
    try testing.expectEqual(1, countReachablePeaks(allocator, table, 2, 5));
    try testing.expectEqual(3, countReachablePeaks(allocator, table, 5, 5));
    try testing.expectEqual(5, countReachablePeaks(allocator, table, 0, 6));
    try testing.expectEqual(3, countReachablePeaks(allocator, table, 6, 6));
    try testing.expectEqual(5, countReachablePeaks(allocator, table, 1, 7));
}

test "star2" {
    const result = try star2("src/day10/test.txt");
    try testing.expectEqual(81, result);
}
