const std = @import("std");
const testing = std.testing;
const List = std.DoublyLinkedList(u64);
const Node = List.Node;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    std.debug.print("Star 1: {d}\n", .{try star1("src/day11/input.txt")});
}

fn star1(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1024);
    defer allocator.free(content);

    var stones = List{};
    try parse(allocator, &stones, content);
    defer {
        while (stones.pop()) |node| {
            allocator.destroy(node);
        }
    }

    for (0..75) |i| {
        std.debug.print("{d}\n", .{i});
        try update(allocator, &stones);
    }

    return stones.len;
}

fn parse(allocator: Allocator, stones: *List, content: []const u8) !void {
    var tokens = std.mem.tokenizeAny(u8, content, " \n");
    while (tokens.next()) |token| {
        const stone = try std.fmt.parseInt(u64, token, 10);
        var node = try allocator.create(Node);
        node.data = stone;
        stones.append(node);
    }
}

fn update(allocator: Allocator, stones: *List) !void {
    var it = stones.first;
    while (it) |node| : (it = node.next) {
        try updateNode(allocator, stones, node);
    }
}

fn updateNode(allocator: Allocator, stones: *List, node: *Node) !void {
    if (node.data == 0) {
        node.data = 1;
        return;
    }

    const n = digitCount(node.data);
    if (n % 2 == 0) {
        const s = split(node.data, n / 2);

        const new_node = try allocator.create(Node);
        new_node.data = s.left;
        stones.insertBefore(node, new_node);

        node.data = s.right;
        return;
    }

    node.data *= 2024;
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

test "update" {
    var allocator = std.testing.allocator;
    var stones = List{};
    defer {
        while (stones.pop()) |node| {
            allocator.destroy(node);
        }
    }

    const in = [_]u64{ 0, 1, 10, 99, 999 };
    for (in) |i| {
        var node = try allocator.create(Node);
        node.data = i;
        stones.append(node);
    }

    try update(allocator, &stones);

    const expected = [_]u64{ 1, 2024, 1, 0, 9, 9, 2021976 };
    var node = stones.first;
    var i: usize = 0;
    while (node) |n| : ({
        node = n.next;
    }) {
        try testing.expectEqual(expected[i], n.data);
        i += 1;
    }
}
