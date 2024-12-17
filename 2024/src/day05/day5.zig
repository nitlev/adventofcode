const std = @import("std");
const testing = std.testing;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    std.debug.print("Star 1: {}\n", .{try star1("src/day5/input.txt")});
    std.debug.print("Star 2: {}\n", .{try star2("src/day5/input.txt")});
}

fn star1(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const content = try read(allocator, path);
    defer allocator.free(content);

    var sections = std.mem.tokenizeSequence(u8, content, "\n\n");
    const rules = try parseRules(allocator, sections.next() orelse "");
    defer allocator.free(rules);

    const updates = try parseUpdates(allocator, sections.next() orelse "");
    defer {
        for (updates) |update| {
            allocator.free(update);
        }
        allocator.free(updates);
    }

    var total: usize = 0;
    const context = Context{ .rules = rules };
    for (updates) |update| {
        if (std.sort.isSorted(u8, update, context, Context.lessThan)) {
            total += @intCast(extractMiddle(update));
        }
    }

    return total;
}

fn star2(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const content = try read(allocator, path);
    defer allocator.free(content);

    var sections = std.mem.tokenizeSequence(u8, content, "\n\n");
    const rules = try parseRules(allocator, sections.next() orelse "");
    defer allocator.free(rules);

    const updates = try parseUpdates(allocator, sections.next() orelse "");
    defer {
        for (updates) |update| {
            allocator.free(update);
        }
        allocator.free(updates);
    }

    var total: usize = 0;
    const context = Context{ .rules = rules };
    for (updates) |update| {
        if (!std.sort.isSorted(u8, update, context, Context.lessThan)) {
            std.mem.sort(u8, update, context, Context.lessThan);
            total += @intCast(extractMiddle(update));
        }
    }

    return total;
}

fn read(allocator: Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const result = try file.readToEndAlloc(allocator, 1014 * 1024);
    return result;
}

const Rule = struct { first: u8, second: u8 };

fn parseRules(allocator: Allocator, raw_rules: []const u8) ![]Rule {
    var rules = ArrayList(Rule).init(allocator);
    defer rules.deinit();

    var lines = std.mem.tokenizeScalar(u8, raw_rules, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var parts = std.mem.splitScalar(u8, line, '|');
        const rule = Rule{
            .first = try std.fmt.parseInt(u8, parts.first(), 10),
            .second = try std.fmt.parseInt(u8, parts.rest(), 10),
        };
        try rules.append(rule);
    }

    return rules.toOwnedSlice();
}

fn parseUpdates(allocator: Allocator, raw_updates: []const u8) ![][]u8 {
    var updates = ArrayList([]u8).init(allocator);
    defer updates.deinit();
    var update = ArrayList(u8).init(allocator);
    defer update.deinit();

    var lines = std.mem.tokenizeScalar(u8, raw_updates, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var parts = std.mem.splitScalar(u8, line, ',');
        while (parts.next()) |part| {
            try update.append(std.fmt.parseInt(u8, part, 10) catch unreachable);
        }
        try updates.append(try update.toOwnedSlice());
        update.clearAndFree();
    }

    return updates.toOwnedSlice();
}

const Context = struct {
    rules: []Rule,

    pub fn lessThan(self: Context, a: u8, b: u8) bool {
        for (self.rules) |rule| {
            if (rule.first == a and rule.second == b) {
                return true;
            }
        }
        return false;
    }
};

fn extractMiddle(update: []u8) u8 {
    const middle = update.len / 2;
    return update[middle];
}

test "Star 1" {
    try testing.expectEqual(143, try star1("src/day5/test.txt"));
}

test "Star 2" {
    try testing.expectEqual(123, try star2("src/day5/test.txt"));
}
