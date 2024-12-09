const std = @import("std");
const testing = std.testing;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    std.debug.print("Star 1: {}\n", .{try star1("src/day7/input.txt")});
    std.debug.print("Star 2: {}\n", .{try star2("src/day7/input.txt")});
}

fn star1(path: []const u8) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1014 * 1024);
    defer allocator.free(content);

    var total: u64 = 0;
    var lines = std.mem.tokenizeScalar(u8, content, '\n');
    while (lines.next()) |line| {
        var equation = try parseEquation(allocator, line);
        defer allocator.free(equation.operands);

        if (equation.isSolvable()) {
            total += equation.test_value;
        }
    }

    return total;
}

fn star2(path: []const u8) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1014 * 1024);
    defer allocator.free(content);

    var total: u64 = 0;
    var lines = std.mem.tokenizeScalar(u8, content, '\n');
    while (lines.next()) |line| {
        var equation = try parseEquation(allocator, line);
        defer allocator.free(equation.operands);

        if (equation.isSolvableWithConcat()) {
            total += equation.test_value;
        }
    }

    return total;
}

const Equation = struct {
    test_value: u64,
    operands: []u64,

    pub fn isSolvable(self: *Equation) bool {
        return self.recursiveSolve(self.operands[0], self.operands[1..]);
    }

    fn recursiveSolve(self: *Equation, current_value: u64, remaining_operands: []u64) bool {
        if (remaining_operands.len == 0) {
            return current_value == self.test_value;
        }

        return self.recursiveSolve(current_value + remaining_operands[0], remaining_operands[1..]) or
            self.recursiveSolve(current_value * remaining_operands[0], remaining_operands[1..]);
    }

    pub fn isSolvableWithConcat(self: *Equation) bool {
        return self.recursiveSolveWithConcat(self.operands[0], self.operands[1..]);
    }

    fn recursiveSolveWithConcat(self: *Equation, current_value: u64, remaining_operands: []u64) bool {
        if (remaining_operands.len == 0) {
            return current_value == self.test_value;
        }

        return self.recursiveSolveWithConcat(current_value + remaining_operands[0], remaining_operands[1..]) or
            self.recursiveSolveWithConcat(current_value * remaining_operands[0], remaining_operands[1..]) or
            self.recursiveSolveWithConcat(concat(current_value, remaining_operands[0]), remaining_operands[1..]);
    }

    fn concat(left: u64, right: u64) u64 {
        var n = right;
        var l = left;
        while (n != 0) {
            l *= 10;
            n /= 10;
        }
        return l + right;
    }
};

fn parseEquation(allocator: Allocator, line: []const u8) !Equation {
    var parts = std.mem.tokenizeAny(u8, line, ":");
    const test_value = try std.fmt.parseInt(u64, parts.next() orelse "0", 10);

    var operand_list = ArrayList(u64).init(allocator);
    defer operand_list.deinit();
    var operand_values = std.mem.tokenizeScalar(u8, parts.next().?, ' ');
    while (operand_values.next()) |part| {
        const operand = try std.fmt.parseInt(u64, part, 10);
        try operand_list.append(operand);
    }
    const operands = try operand_list.toOwnedSlice();

    return Equation{ .test_value = test_value, .operands = operands };
}

test "Star 1" {
    try testing.expectEqual(3749, try star1("src/day7/test.txt"));
}

test "Star 2" {
    try testing.expectEqual(11387, try star2("src/day7/test.txt"));
}
