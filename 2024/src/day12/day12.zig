const std = @import("std");
const testing = std.testing;
const AutoHashMap = std.AutoHashMap;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    std.debug.print("Star 1: {d}\n", .{try star1("src/day12/input.txt")});
}

fn star1(path: []const u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(content);

    var map = Map.init(allocator);
    defer map.deinit();
    try parse(content, &map);

    return computePrice(allocator, &map);
}

const Coordinates = struct { i: isize, j: isize };
const Patch = struct { type: u8, is_visited: bool };
const Map = AutoHashMap(Coordinates, Patch);

fn parse(content: []const u8, map: *Map) !void {
    var lines = std.mem.tokenizeScalar(u8, content, '\n');
    var i: usize = 0;
    while (lines.next()) |line| {
        for (line, 0..) |patch, j| {
            try map.put(
                .{ .i = @intCast(i), .j = @intCast(j) },
                .{ .type = patch, .is_visited = false },
            );
        }
        i += 1;
    }
}

const Region = struct {
    type: u8,
    area: usize,
    perimeter: usize,

    pub fn price(self: Region) !usize {
        return self.area * self.perimeter;
    }
};

fn computePrice(allocator: Allocator, map: *Map) !usize {
    var total_price: usize = 0;
    var it = map.iterator();
    while (it.next()) |entry| {
        if (entry.value_ptr.is_visited) {
            continue;
        }
        const region = try exploreFrom(allocator, map, entry.key_ptr.*);
        const price = try region.price();

        total_price += price;
    }
    return total_price;
}

fn exploreFrom(allocator: Allocator, map: *Map, coordinates: Coordinates) !Region {
    var stack = std.ArrayList(Coordinates).init(allocator);
    defer stack.deinit();
    try stack.append(coordinates);

    var region = Region{
        .type = map.get(coordinates).?.type,
        .area = 0,
        .perimeter = 0,
    };
    while (stack.popOrNull()) |current| {
        const patch = map.getPtr(current) orelse continue;
        if (patch.is_visited) {
            continue;
        }
        patch.is_visited = true;
        region.area += 1;

        const neighbors = [_]Coordinates{
            .{ .i = current.i - 1, .j = current.j },
            .{ .i = current.i + 1, .j = current.j },
            .{ .i = current.i, .j = current.j - 1 },
            .{ .i = current.i, .j = current.j + 1 },
        };
        for (neighbors) |neighbor| {
            if (map.get(neighbor)) |p| {
                if (p.type != region.type) {
                    region.perimeter += 1;
                } else if (!p.is_visited) {
                    try stack.append(neighbor);
                }
            } else {
                region.perimeter += 1;
            }
        }
    }

    return region;
}

test "star1" {
    const expected = 1930;
    const result = try star1("src/day12/test.txt");
    try testing.expectEqual(expected, result);
}
