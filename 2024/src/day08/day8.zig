const std = @import("std");
const testing = std.testing;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const HashMap = std.AutoHashMap;

pub fn main() !void {
    std.debug.print("Star 1: {}\n", .{try star1("src/day8/input.txt")});
    std.debug.print("Star 2: {}\n", .{try star2("src/day8/input.txt")});
}

const Location = struct {
    x: u8,
    y: u8,
    frequency: ?u8,
    has_antinode: bool,
};

fn star1(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1014 * 1024);
    defer allocator.free(content);

    // parse the input
    var map = Map.init(allocator);
    try map.parseFromString(content);
    defer map.deinit();

    // compute antinode locations
    map.computeAntinodes();

    return map.countAntinodes();
}
fn star2(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1014 * 1024);
    defer allocator.free(content);

    // parse the input
    var map = Map.init(allocator);
    try map.parseFromString(content);
    defer map.deinit();

    // compute antinode locations
    map.computeHarmonicAntinodes();

    return map.countAntinodes();
}

const Coordinates = struct {
    x: u8,
    y: u8,
};

const Map = struct {
    locations: HashMap(Coordinates, Location),
    frequency_locations: HashMap(u8, ArrayList(Location)),
    allocator: Allocator,
    size_x: u8 = 0,
    size_y: u8 = 0,

    pub fn init(allocator: Allocator) Map {
        return Map{
            .locations = HashMap(Coordinates, Location).init(allocator),
            .frequency_locations = HashMap(u8, ArrayList(Location)).init(allocator),
            .allocator = allocator,
        };
    }
    fn parseFromString(self: *Map, content: []const u8) !void {
        var lines = std.mem.tokenizeScalar(u8, content, '\n');
        var x: u8 = 0;
        var y: u8 = 0;

        while (lines.next()) |line| {
            x = 0;
            for (line) |c| {
                switch (c) {
                    '.' => try self.addLocation(.{
                        .x = @intCast(x),
                        .y = y,
                        .frequency = null,
                        .has_antinode = false,
                    }),
                    else => try self.addLocation(.{
                        .x = @intCast(x),
                        .y = y,
                        .frequency = c,
                        .has_antinode = false,
                    }),
                }
                x += 1;
            }
            y += 1;
        }

        self.size_x = x;
        self.size_y = y;
    }

    pub fn deinit(self: *Map) void {
        self.locations.deinit();
        var location_iter = self.frequency_locations.valueIterator();
        while (location_iter.next()) |l| {
            l.deinit();
        }
        self.frequency_locations.deinit();
    }

    pub fn addLocation(self: *Map, location: Location) !void {
        try self.locations.put(.{ .x = location.x, .y = location.y }, location);
        if (location.frequency) |frequency| {
            if (self.frequency_locations.getPtr(frequency)) |locations| {
                try locations.append(location);
            } else {
                var list = ArrayList(Location).init(self.allocator);
                try list.append(location);
                try self.frequency_locations.put(frequency, list);
            }
        }
    }

    fn computeAntinodes(self: *Map) void {
        var frequency_location_iter = self.frequency_locations.iterator();
        while (frequency_location_iter.next()) |entry| {
            const locations = entry.value_ptr.*;
            for (locations.items) |location1| {
                for (locations.items) |location2| {
                    const dx: i16 = @as(i16, location2.x) - @as(i16, location1.x);
                    const dy: i16 = @as(i16, location2.y) - @as(i16, location1.y);

                    if (dx < 0 or (dx == 0 and dy <= 0)) {
                        continue;
                    }

                    const new_x1 = @as(i16, location2.x) + dx;
                    const new_y1 = @as(i16, location2.y) + dy;
                    if (new_x1 >= 0 and new_x1 < self.size_x and new_y1 >= 0 and new_y1 < self.size_y) {
                        self.locations.getPtr(.{ .x = @intCast(new_x1), .y = @intCast(new_y1) }).?.has_antinode = true;
                    }

                    const new_x2 = @as(i16, location1.x) - dx;
                    const new_y2 = @as(i16, location1.y) - dy;
                    if (new_x2 >= 0 and new_x2 < self.size_x and new_y2 >= 0 and new_y2 < self.size_y) {
                        self.locations.getPtr(.{ .x = @intCast(new_x2), .y = @intCast(new_y2) }).?.has_antinode = true;
                    }
                }
            }
        }
    }

    fn computeHarmonicAntinodes(self: *Map) void {
        var frequency_location_iter = self.frequency_locations.iterator();
        while (frequency_location_iter.next()) |entry| {
            const locations = entry.value_ptr.*;
            for (locations.items) |location1| {
                for (locations.items) |location2| {
                    const dx: i16 = @as(i16, location2.x) - @as(i16, location1.x);
                    const dy: i16 = @as(i16, location2.y) - @as(i16, location1.y);

                    if (dx == 0 and dy == 0) {
                        continue;
                    }

                    var new_x1 = @as(i16, location2.x);
                    var new_y1 = @as(i16, location2.y);
                    while (new_x1 >= 0 and new_x1 < self.size_x and new_y1 >= 0 and new_y1 < self.size_y) {
                        self.locations.getPtr(.{ .x = @intCast(new_x1), .y = @intCast(new_y1) }).?.has_antinode = true;
                        new_x1 += dx;
                        new_y1 += dy;
                    }

                    var new_x2 = @as(i16, location2.x);
                    var new_y2 = @as(i16, location2.y);
                    while (new_x2 >= 0 and new_x2 < self.size_x and new_y2 >= 0 and new_y2 < self.size_y) {
                        self.locations.getPtr(.{ .x = @intCast(new_x2), .y = @intCast(new_y2) }).?.has_antinode = true;
                        new_x2 -= dx;
                        new_y2 -= dy;
                    }
                }
            }
        }
    }

    pub fn countAntinodes(self: *Map) usize {
        var location_iter = self.locations.valueIterator();
        var total: usize = 0;
        while (location_iter.next()) |location| {
            if (location.has_antinode) {
                total += 1;
            }
        }
        return total;
    }

    fn print(self: *Map) void {
        for (0..self.size_y) |y| {
            for (0..self.size_x) |x| {
                const location = self.locations.getPtr(.{ .x = @intCast(x), .y = @intCast(y) }).?;
                if (location.has_antinode) {
                    std.debug.print("X", .{});
                } else {
                    std.debug.print(".", .{});
                }
            }
            std.debug.print("\n", .{});
        }
    }
};

test "Star 1" {
    try testing.expectEqual(14, try star1("src/day8/test.txt"));
}

test "Star 2" {
    try testing.expectEqual(9, try star2("src/day8/test2.txt"));
    try testing.expectEqual(34, try star2("src/day8/test.txt"));
}
