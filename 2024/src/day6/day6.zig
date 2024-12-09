const std = @import("std");
const testing = std.testing;
const AutoHashMap = std.AutoHashMap;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    std.debug.print("Star 1: {}\n", .{try star1("src/day6/input.txt")});
}

const CellKey = struct {
    x: i32,
    y: i32,
};

const Cell = struct {
    key: CellKey,
    isVisited: bool,
    isObstacle: bool,
};

const Guard = struct {
    x: i32,
    y: i32,
    speed_x: i32,
    speed_y: i32,
};

fn star1(path: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const content = try read(allocator, path);
    defer allocator.free(content);

    var cells = AutoHashMap(CellKey, Cell).init(allocator);
    defer cells.deinit();

    var rows = std.mem.tokenizeScalar(u8, content, '\n');
    var i: i32 = 0;
    var j: i32 = 0;
    var guard: Guard = undefined;
    while (rows.next()) |row| {
        j = 0;
        for (row) |c| {
            switch (c) {
                '.' => {
                    try cells.put(CellKey{ .x = j, .y = i }, Cell{ .key = CellKey{ .x = i, .y = j }, .isVisited = false, .isObstacle = false });
                },
                '#' => {
                    try cells.put(CellKey{ .x = j, .y = i }, Cell{ .key = CellKey{ .x = i, .y = j }, .isVisited = false, .isObstacle = true });
                },
                '^' => {
                    try cells.put(CellKey{ .x = j, .y = i }, Cell{ .key = CellKey{ .x = i, .y = j }, .isVisited = true, .isObstacle = false });
                    guard = Guard{ .x = j, .y = i, .speed_x = 0, .speed_y = -1 };
                },
                else => unreachable,
            }
            j += 1;
        }
        i += 1;
    }

    var total: usize = 0;
    while (update(&cells, &guard)) |_| {
        if (guard.x < 0 or guard.y < 0 or guard.x >= i or guard.y >= j) {
            break;
        }
    } else |_| {
        var cell_iter = cells.iterator();
        while (cell_iter.next()) |cell| {
            if (cell.value_ptr.isVisited) {
                total += 1;
            }
        }
    }

    return total;
}

const SimulationError = error{OutOfBounds};

fn update(cells: *AutoHashMap(CellKey, Cell), guard: *Guard) !void {
    const next_location = CellKey{ .x = guard.x + guard.speed_x, .y = guard.y + guard.speed_y };
    if (cells.getPtr(next_location)) |next_cell| {
        if (next_cell.isObstacle) {
            // Rotate 90 degrees
            const tmp = guard.speed_x;
            guard.speed_x = -guard.speed_y;
            guard.speed_y = tmp;
        } else {
            next_cell.isVisited = true;
            guard.x = next_location.x;
            guard.y = next_location.y;
        }
    } else {
        return SimulationError.OutOfBounds;
    }
}

fn read(allocator: Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    return file.readToEndAlloc(allocator, 1014 * 1024);
}

test "Star 1" {
    try testing.expectEqual(41, try star1("src/day6/test.txt"));
}
