const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day06.txt");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    print("Part 1: {any}\n", .{part1(arena, data)});
    print("Part 2: {any}\n", .{part2(arena, data)});
}

// -1: termination. 0: ahead is an empty position. 1: ahead is an obstacle
// Facing should be 0: up, 1: right, 2: down, 3: left
fn aheadIs(grid: std.ArrayList([]const u8), i: usize, j: usize, facing: i32) i32 {
    var newI = i;
    var newJ = j;
    if (facing == 0) {
        if (i == 0) {
            return -1;
        }
        newI -= 1;
    } else if (facing == 1) {
        if (j == grid.items[0].len - 1) {
            return -1;
        }
        newJ += 1;
    } else if (facing == 2) {
        if (i == grid.items.len - 1) {
            return -1;
        }
        newI += 1;
    } else if (facing == 3) {
        if (j == 0) {
            return -1;
        }
        newJ -= 1;
    } else {
        return -2;
    }

    if (grid.items[newI][newJ] == '#') {
        return 1;
    }
    return 0;
}

// -1: termination. 0: ahead is an empty position. 1: ahead is an obstacle
// Facing should be 0: up, 1: right, 2: down, 3: left
fn aheadIsMut(grid: std.ArrayList([]u8), i: usize, j: usize, facing: i32) i32 {
    var newI = i;
    var newJ = j;
    if (facing == 0) {
        if (i == 0) {
            return -1;
        }
        newI -= 1;
    } else if (facing == 1) {
        if (j == grid.items[0].len - 1) {
            return -1;
        }
        newJ += 1;
    } else if (facing == 2) {
        if (i == grid.items.len - 1) {
            return -1;
        }
        newI += 1;
    } else if (facing == 3) {
        if (j == 0) {
            return -1;
        }
        newJ -= 1;
    } else {
        return -2;
    }

    if (grid.items[newI][newJ] == '#') {
        return 1;
    }
    return 0;
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var grid = std.ArrayList([]const u8).init(allocator);
    grid.deinit();
    var lineCount: usize = 0;
    var i: usize = 0;
    var j: usize = 0;
    while (inputLines.next()) |line| {
        const start = indexOf(u8, line, '^');
        if (start) |*value| {
            i = lineCount;
            j = value.*;
        }
        grid.append(line) catch {
            return error.Muisti;
        };

        lineCount += 1;
    }
    var beenThere = std.AutoHashMap(usize, bool).init(allocator);
    defer beenThere.deinit();

    var facing: i32 = 0;
    var steps: i32 = 1;
    beenThere.put(i * 200 + j, true) catch {
        return error.OivOi;
    };
    while (true) {
        const next = aheadIs(grid, i, j, facing);
        if (next == -1) {
            break;
        } else if (next == 1) {
            facing = @mod(facing + 1, 4);
            continue;
        } else {
            if (facing == 0) {
                i -= 1;
            } else if (facing == 1) {
                j += 1;
            } else if (facing == 2) {
                i += 1;
            } else if (facing == 3) {
                j -= 1;
            } else {
                return error.Buruhurhuh;
            }

            if (beenThere.contains(i * 200 + j)) {
                continue;
            } else {
                beenThere.put(i * 200 + j, true) catch {
                    return error.OivOi;
                };
                steps += 1;
            }
        }
    }

    return steps;
}

fn countSteps(allocator: Allocator, grid: std.ArrayList([]u8), begi: usize, begj: usize) i32 {
    var i = begi;
    var j = begj;

    var beenThere = std.AutoHashMap(usize, bool).init(allocator);
    defer beenThere.deinit();

    var iterations: i32 = -1;
    var facing: i32 = 0;
    var steps: i32 = 1;
    beenThere.put(i * 200 + j, true) catch {
        return -2;
    };
    while (true) {
        iterations += 1;
        const next = aheadIsMut(grid, i, j, facing);
        if (next == -1) {
            break;
        } else if (next == 1) {
            facing = @mod(facing + 1, 4);
            continue;
        } else {
            if (facing == 0) {
                i -= 1;
            } else if (facing == 1) {
                j += 1;
            } else if (facing == 2) {
                i += 1;
            } else if (facing == 3) {
                j -= 1;
            } else {
                return -2;
            }

            if (beenThere.contains(i * 200 + j)) {
                if (iterations > 20000) {
                    return -1;
                }
                continue;
            } else {
                beenThere.put(i * 200 + j, true) catch {
                    return -2;
                };
                steps += 1;
            }
        }
    }
    return steps;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var grid = std.ArrayList([]const u8).init(allocator);
    var alterable = std.ArrayList([]u8).init(allocator);

    grid.deinit();
    var lineCount: usize = 0;
    var i: usize = 0;
    var j: usize = 0;
    while (inputLines.next()) |line| {
        const start = indexOf(u8, line, '^');
        if (start) |*value| {
            i = lineCount;
            j = value.*;
        }
        grid.append(line) catch {
            return error.Muisti;
        };

        const a = allocator.alloc(u8, line.len) catch {
            return error.Muisti;
        };
        @memcpy(a, line);
        alterable.append(a) catch {
            return error.Muisti;
        };

        lineCount += 1;
    }

    var cum: i32 = 0;
    for (0..lineCount) |row| {
        for (0..grid.items[0].len) |col| {
            if (grid.items[row][col] == '#' or grid.items[row][col] == '^') {
                continue;
            }
            alterable.items[row][col] = '#';
            const steps = countSteps(allocator, alterable, i, j);
            alterable.items[row][col] = '.';

            if (steps == -1) {
                cum += 1;
            }
        }
    }

    return cum;
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.

test "part 1 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\....#.....
        \\.........#
        \\..........
        \\..#.......
        \\.......#..
        \\..........
        \\.#..^.....
        \\........#.
        \\#.........
        \\......#...
    ;

    try std.testing.expectEqual(41, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\....#.....
        \\.........#
        \\..........
        \\..#.......
        \\.......#..
        \\..........
        \\.#..^.....
        \\........#.
        \\#.........
        \\......#...
    ;

    try std.testing.expectEqual(6, try part2(arena, example_input));
}
