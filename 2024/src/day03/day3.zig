const std = @import("std");
const testing = std.testing;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    std.debug.print("Star 1: {}\n", .{try star1("src/day3/input.txt")});
}

// We're going crazy today and we'll implement our custom regex automaton.
const TokenType = enum {
    LiteralM,
    LiteralU,
    LiteralL,
    OpeningParenthesis,
    ClosingParenthesis,
    Digit,
    Comma,
    Invalid,
};

const Token = struct {
    type: TokenType,
    value: u8,
};

fn tokenize(content: []const u8) ![]Token {
    const allocator = std.heap.page_allocator;
    var tokens = ArrayList(Token).init(allocator);
    defer tokens.deinit();

    for (content) |c| {
        const token: Token = switch (c) {
            'm' => .{ .type = .LiteralM, .value = c },
            'u' => .{ .type = .LiteralU, .value = c },
            'l' => .{ .type = .LiteralL, .value = c },
            '(' => .{ .type = .OpeningParenthesis, .value = c },
            ')' => .{ .type = .ClosingParenthesis, .value = c },
            ',' => .{ .type = .Comma, .value = c },
            '0'...'9' => .{ .type = .Digit, .value = c },
            else => .{ .type = .Invalid, .value = c },
        };
        try tokens.append(token);
    }

    return tokens.toOwnedSlice();
}

const State = struct {
    last_token: ?Token,
    digit_count: u8,
    operand_count: u8,
    current_match: ArrayList(u8),
    matches: ArrayList([]const u8),

    pub fn init(allocator: Allocator) State {
        return State{
            .last_token = null,
            .digit_count = 0,
            .operand_count = 0,
            .current_match = ArrayList(u8).init(allocator),
            .matches = ArrayList([]const u8).init(allocator),
        };
    }

    pub fn deinit(self: *State) void {
        self.current_match.deinit();
        self.matches.deinit();
    }

    pub fn reset(self: *State) void {
        self.last_token = null;
        self.digit_count = 0;
        self.operand_count = 0;
        self.current_match.clearAndFree();
    }

    pub fn parse(self: *State, tokens: []Token) ![]const []const u8 {
        for (tokens) |token| {
            try self.step(token);
        }
        return self.matches.items;
    }

    pub fn step(self: *State, token: Token) !void {
        if (self.last_token) |last_token| {
            self.last_token = token;
            try self.current_match.append(token.value);
            switch (token.type) {
                .LiteralU => {
                    if (!(last_token.type == .LiteralM)) {
                        self.reset();
                    }
                },
                .LiteralL => {
                    if (!(last_token.type == .LiteralU)) {
                        self.reset();
                    }
                },
                .OpeningParenthesis => {
                    if (!(last_token.type == .LiteralL)) {
                        self.reset();
                    } else {
                        self.operand_count = 1;
                    }
                },
                .Digit => {
                    self.digit_count += 1;
                    if (self.digit_count > 3) {
                        self.reset();
                    }
                },
                .Comma => {
                    if (!(last_token.type == .Digit)) {
                        self.reset();
                    } else {
                        self.operand_count += 1;
                        self.digit_count = 0;
                    }
                },
                .ClosingParenthesis => {
                    if (!(last_token.type == .Digit)) {
                        self.reset();
                    } else if (self.operand_count != 2) {
                        self.reset();
                    } else {
                        const match = try self.current_match.toOwnedSlice();
                        try self.matches.append(match);
                        std.debug.print("Match: {s}\n", .{match});
                        self.reset();
                    }
                },
                else => {
                    self.reset();
                },
            }
        } else {
            switch (token.type) {
                .LiteralM => {
                    self.last_token = token;
                    try self.current_match.append(token.value);
                },
                else => {},
            }
        }
    }
};

fn star1(path: []const u8) !usize {
    const allocator = std.heap.page_allocator;

    const content = try read(allocator, path);
    defer allocator.free(content);

    const tokens = try tokenize(content);
    var state = State.init(allocator);
    defer state.deinit();

    const matches = try state.parse(tokens);
    var total: usize = 0;

    for (matches) |match| {
        var mul: usize = 1;
        var t = std.mem.tokenizeAny(u8, match, "mul(),");
        while (t.next()) |token| {
            mul *= try std.fmt.parseInt(usize, token, 10);
        }
        total += mul;
    }

    return total;
}

pub fn read(allocator: Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const result = try file.readToEndAlloc(allocator, 1014 * 1024);
    return result;
}

test "Star 1" {
    try testing.expectEqual(161, try star1("src/day3/test.txt"));
}
