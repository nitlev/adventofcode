const std = @import("std");
const testing = std.testing;
const AutoHashMap = std.AutoHashMap;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    std.debug.print("Star 1: {d}\n", .{try star1("src/day11/input.txt")});
    std.debug.print("Star 2: {d}\n", .{try star2("src/day11/input.txt")});
}

const StoneMap = AutoHashMap(u64, usize);

fn star1(path: []const u8) !usize {
    return try star(path, 25);
}

fn star2(path: []const u8) !usize {
    return try star(path, 75);
}

fn star(path: []const u8, n_iter: usize) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1024);
    defer allocator.free(content);

    var current_stones = StoneMap.init(allocator);
    defer current_stones.deinit();
    var new_stones = StoneMap.init(allocator);
    defer new_stones.deinit();

    try parse(&current_stones, content);

    for (0..n_iter) |i| {
        try update(&current_stones, &new_stones);
        // Swap maps
        const stones = current_stones;
        current_stones = new_stones;
        new_stones = stones;
        new_stones.clearRetainingCapacity();

        std.debug.print("{d}\n", .{i});
    }

    return countStones(&current_stones);
}

fn parse(stones: *StoneMap, content: []const u8) !void {
    var tokens = std.mem.tokenizeAny(u8, content, " \n");
    while (tokens.next()) |token| {
        const stone = try std.fmt.parseInt(u64, token, 10);
        const current_value = stones.get(stone) orelse 0;
        try stones.put(stone, current_value + 1);
    }
}

fn update(current_stones: *StoneMap, new_stones: *StoneMap) !void {
    var it = current_stones.iterator();
    while (it.next()) |entry| {
        const stone = entry.key_ptr.*;
        const count = entry.value_ptr.*;
        if (stone == 0) {
            try updateStone(new_stones, 1, count);
            continue;
        }

        const n = digitCount(stone);
        if (n % 2 == 0) {
            const s = split(stone, n / 2);
            try updateStone(new_stones, s.left, count);
            try updateStone(new_stones, s.right, count);
            continue;
        }

        try updateStone(new_stones, stone * 2024, count);
    }
}

fn updateStone(stones: *StoneMap, stone: u64, count: usize) !void {
    const c = stones.get(stone) orelse 0;
    try stones.put(stone, c + count);
}

fn digitCount(number: u64) u64 {
    var count: u64 = 0;
    var n = number;
    while (n != 0) {
        count += 1;
        n /= 10;
    }
    return count;
}

fn split(number: u64, index: u64) Split {
    var left: u64 = number;
    var right: u64 = 0;
    var i: u64 = 0;
    while (left != 0 and i < index) {
        right = (left % 10) * std.math.pow(u64, 10, i) + right;
        left /= 10;
        i += 1;
    }
    return .{ .left = left, .right = right };
}

fn countStones(stones: *const StoneMap) usize {
    var total: usize = 0;
    var it = stones.iterator();
    while (it.next()) |entry| {
        total += entry.value_ptr.*;
    }
    return total;
}

const Split = struct {
    left: u64,
    right: u64,
};

test "digitCount" {
    try testing.expectEqual(0, digitCount(0));
    try testing.expectEqual(1, digitCount(1));
    try testing.expectEqual(2, digitCount(10));
    try testing.expectEqual(3, digitCount(123));
    try testing.expectEqual(4, digitCount(1234));
}

test "split" {
    const s = split(1234, 2);
    try testing.expectEqual(12, s.left);
    try testing.expectEqual(34, s.right);
}

test "star1" {
    try testing.expectEqual(55312, try star1("src/day11/test.txt"));
}
