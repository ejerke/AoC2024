const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    print("Part 1: {any}\n", .{part1(arena, data)});
    print("Part 2: {any}\n", .{part2(arena, data)});
}

fn isValidXmas(list: std.ArrayList([]const u8), i: usize, j: usize) i32 {
    var count: i32 = 0;
    // Right
    if ( j < list.items[0].len - 3 and list.items[i][j+1] == 'M' and list.items[i][j+2] == 'A' and list.items[i][j+3] == 'S') {
        count += 1;
    }
    // Left
    if ( j >= 3 and list.items[i][j-1] == 'M' and list.items[i][j-2] == 'A' and list.items[i][j-3] == 'S') {
        count += 1;
    }

    // Right up
    if ( i >= 3 and j < list.items[0].len - 3 and list.items[i-1][j+1] == 'M' and list.items[i-2][j+2] == 'A' and list.items[i-3][j+3] == 'S') {
        count += 1;
    }

    // Right down
    if ( i < list.items.len - 3 and j < list.items[0].len - 3 and list.items[i+1][j+1] == 'M' and list.items[i+2][j+2] == 'A' and list.items[i+3][j+3] == 'S') {
        count += 1;
    }

    // Down
    if ( i < list.items.len - 3 and list.items[i+1][j] == 'M' and list.items[i+2][j] == 'A' and list.items[i+3][j] == 'S') {
        count += 1;
    }

    // Left down
    if ( i < list.items.len - 3 and j >= 3 and list.items[i+1][j-1] == 'M' and list.items[i+2][j-2] == 'A' and list.items[i+3][j-3] == 'S') {
        count += 1;
    }

    // Left up
    if ( i >= 3 and j >= 3 and list.items[i-1][j-1] == 'M' and list.items[i-2][j-2] == 'A' and list.items[i-3][j-3] == 'S') {
        count += 1;
    }

    // Up
    if ( i >= 3 and list.items[i-1][j] == 'M' and list.items[i-2][j] == 'A' and list.items[i-3][j] == 'S') {
        count += 1;
    }


    return count;
}

fn isValidMas(list: std.ArrayList([]const u8), i: usize, j:usize) bool {
    if (j == 0 or i == 0 or i >= list.items.len - 1 or j >= list.items[0].len - 1) {
        return false;
    }

    // Left
    if ( list.items[i-1][j-1] == 'M' and list.items[i+1][j-1] == 'M' and list.items[i-1][j+1] == 'S' and list.items[i+1][j+1] == 'S') {
        return true;
    }

    // Right
    if ( list.items[i-1][j+1] == 'M' and list.items[i+1][j+1] == 'M' and list.items[i-1][j-1] == 'S' and list.items[i+1][j-1] == 'S') {
        return true;
    }

    // Up
    if ( list.items[i-1][j+1] == 'M' and list.items[i-1][j-1] == 'M' and list.items[i+1][j-1] == 'S' and list.items[i+1][j+1] == 'S') {
        return true;
    }

    // Down
    if ( list.items[i+1][j+1] == 'M' and list.items[i+1][j-1] == 'M' and list.items[i-1][j-1] == 'S' and list.items[i-1][j+1] == 'S') {
        return true;
    }

    return false;
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var lines = std.ArrayList([]const u8).init(allocator);
    var len: usize = 0;
    while (inputLines.next()) |line| {
        len = line.len;
        try lines.append(line);
    }
    var ans: i32 = 0;
    for (lines.items, 0..lines.items.len) |line, i| {
        for (line, 0..len) |char, j| {
            if (char == 'X') {
                const ret = isValidXmas(lines, i, j);
                ans += ret;
            }
        }
    }

    return ans;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var lines = std.ArrayList([]const u8).init(allocator);
    var len: usize = 0;
    while (inputLines.next()) |line| {
        len = line.len;
        try lines.append(line);
    }
    var ans: i32 = 0;
    for (lines.items, 0..lines.items.len) |line, i| {
        for (line, 0..len) |char, j| {
            if (char == 'A') {
                if (isValidMas(lines, i, j)) {
                    ans += 1;
                }
            }
        }
    }

    return ans;
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
        \\..X...
        \\.SAMX.
        \\.A..A.
        \\XMAS.S
        \\.X....
    ;
    const example_input_2 = 
        \\....XXMAS.
        \\.SAMXMS...
        \\...S..A...
        \\..A.A.MS.X
        \\XMASAMX.MM
        \\X.....XA.A
        \\S.S.S.S.SS
        \\.A.A.A.A.A
        \\..M.M.M.MM
        \\.X.X.XMASX
    ;

    try std.testing.expectEqual(4, try part1(arena, example_input));
    try std.testing.expectEqual(18, try part1(arena, example_input_2));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\.M.S......
        \\..A..MSMS.
        \\.M.S.MAA..
        \\..A.ASMSM.
        \\.M.S.M....
        \\..........
        \\S.S.S.S.S.
        \\.A.A.A.A..
        \\M.M.M.M.M.
        \\..........
    ;

    try std.testing.expectEqual(9, try part2(arena, example_input));
}