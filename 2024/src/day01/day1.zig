const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;

pub fn main() !void {
    std.debug.print("Star 1: {}\n", .{try star1("src/day1/input.txt")});
    std.debug.print("Star 2: {}\n", .{try star2("src/day1/input.txt")});
}

fn star1(path: []const u8) !usize {
    const allocator = std.heap.page_allocator;

    const content = try read(allocator, path);
    defer allocator.free(content);

    var it = std.mem.splitScalar(u8, content, '\n');
    var first_numbers = ArrayList(u32).init(allocator);
    var second_numbers = ArrayList(u32).init(allocator);
    while (it.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var numbers = std.mem.splitSequence(u8, line, "   ");
        const first_parsed_number = try std.fmt.parseInt(u32, numbers.next().?, 10);
        const second_parsed_number = try std.fmt.parseInt(u32, numbers.next().?, 10);
        try first_numbers.append(first_parsed_number);
        try second_numbers.append(second_parsed_number);
    }

    std.mem.sort(u32, first_numbers.items, {}, comptime std.sort.asc(u32));
    std.mem.sort(u32, second_numbers.items, {}, comptime std.sort.asc(u32));

    var total_gap: usize = 0;
    for (first_numbers.items, second_numbers.items) |first_idx, second_idx| {
        total_gap += if (first_idx >= second_idx) first_idx - second_idx else second_idx - first_idx;
    }

    return total_gap;
}

fn star2(path: []const u8) !usize {
    const allocator = std.heap.page_allocator;

    const content = try read(allocator, path);
    defer allocator.free(content);

    var first_numbers = AutoHashMap(u32, u32).init(allocator);
    var second_numbers = AutoHashMap(u32, u32).init(allocator);
    defer first_numbers.deinit();
    defer second_numbers.deinit();

    var it = std.mem.splitScalar(u8, content, '\n');
    while (it.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var numbers = std.mem.splitSequence(u8, line, "   ");
        const first_parsed_number = try std.fmt.parseInt(u32, numbers.next().?, 10);
        const second_parsed_number = try std.fmt.parseInt(u32, numbers.next().?, 10);

        try first_numbers.put(first_parsed_number, (first_numbers.get(first_parsed_number) orelse 0) + 1);
        try second_numbers.put(second_parsed_number, (second_numbers.get(second_parsed_number) orelse 0) + 1);
    }

    var it2 = first_numbers.iterator();
    var result: usize = 0;
    while (it2.next()) |entry| {
        result += entry.value_ptr.* * entry.key_ptr.* * (second_numbers.get(entry.key_ptr.*) orelse 0);
    }

    return result;
}

fn read(allocator: Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const result = try file.readToEndAlloc(allocator, 1014 * 1024);
    return result;
}

test "star1" {
    try std.testing.expectEqual(11, star1("src/day1/test.txt"));
}
test "star2" {
    try std.testing.expectEqual(31, star2("src/day1/test.txt"));
}

test "read file" {
    const allocator = std.heap.page_allocator;
    const data = try read(allocator, "src/day1/test.txt");
    try std.testing.expect(std.mem.eql(u8, "3   4\n", data[0..6]));
}
