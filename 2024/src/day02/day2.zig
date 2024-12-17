const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn main() !void {
    std.debug.print("Star 1: {}\n", .{try star1("src/day2/input.txt")});
    std.debug.print("Star 2: {}\n", .{try star2("src/day2/input.txt")});
}

fn star1(path: []const u8) !usize {
    const allocator = std.heap.page_allocator;

    const content = try read(allocator, path);
    defer allocator.free(content);

    var valid_reports: usize = 0;
    var lines = std.mem.splitScalar(u8, content, '\n');
    report: while (lines.next()) |line| {
        if (line.len == 0) {
            continue :report;
        }

        var parsed_numbers = ArrayList(i32).init(allocator);
        defer parsed_numbers.deinit();

        var numbers = std.mem.splitScalar(u8, line, ' ');
        while (numbers.next()) |number| {
            const parsed_number = try std.fmt.parseInt(i32, number, 10);
            try parsed_numbers.append(parsed_number);
        }
        if (checkReport(parsed_numbers.items)) {
            valid_reports += 1;
        }
    }

    return valid_reports;
}

fn star2(path: []const u8) !usize {
    const allocator = std.heap.page_allocator;

    const content = try read(allocator, path);
    defer allocator.free(content);

    var valid_reports: usize = 0;
    var lines = std.mem.splitScalar(u8, content, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var numbers = std.mem.splitScalar(u8, line, ' ');
        var parsed_numbers = ArrayList(i32).init(allocator);
        while (numbers.next()) |number| {
            const parsed_number = try std.fmt.parseInt(i32, number, 10);
            try parsed_numbers.append(parsed_number);
        }
        if (checkDampenedReport(allocator, parsed_numbers.items)) {
            valid_reports += 1;
        } else {}
    }

    return valid_reports;
}

fn checkReport(numbers: []i32) bool {
    var direction_flag: ?bool = null;
    for (numbers[0 .. numbers.len - 1], numbers[1..]) |previous_number, number| {
        if ((previous_number == number) or (number > previous_number + 3) or (number < previous_number - 3)) {
            return false;
        }
        if (direction_flag) |is_decreasing| {
            if (is_decreasing and (number > previous_number)) {
                return false;
            } else if (!is_decreasing and (number < previous_number)) {
                return false;
            }
        }
        direction_flag = number < previous_number;
    }
    return true;
}

fn checkDampenedReport(allocator: Allocator, numbers: []i32) bool {
    var new_numbers = ArrayList(i32).init(allocator);
    defer new_numbers.deinit();

    for (0..numbers.len) |i| {
        for (numbers, 0..) |number, j| {
            if (i == j) {
                continue;
            }
            new_numbers.append(number) catch unreachable;
        }

        if (checkReport(new_numbers.items)) {
            return true;
        }
        new_numbers.clearAndFree();
    }
    return false;
}

fn read(allocator: Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const result = try file.readToEndAlloc(allocator, 1014 * 1024);
    return result;
}

test "star 1" {
    const result = try star1("src/day2/test.txt");
    try testing.expectEqual(2, result);
}

test "star 2" {
    const result = try star2("src/day2/test.txt");
    try testing.expectEqual(4, result);
}

test "check dampened report" {
    const allocator = std.heap.page_allocator;

    var report = [_]i32{ 1, 2, 3, 4, 5 };
    var result = checkDampenedReport(allocator, report[0..]);
    try testing.expect(result);

    report = [_]i32{ 7, 6, 4, 2, 1 };
    result = checkDampenedReport(allocator, report[0..]);
    try testing.expect(result);

    report = [_]i32{ 1, 2, 7, 8, 9 };
    result = checkDampenedReport(allocator, report[0..]);
    try testing.expect(!result);

    report = [_]i32{ 9, 7, 6, 2, 1 };
    result = checkDampenedReport(allocator, report[0..]);
    try testing.expect(!result);

    report = [_]i32{ 1, 3, 2, 4, 5 };
    result = checkDampenedReport(allocator, report[0..]);
    try testing.expect(result);
}
