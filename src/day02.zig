const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

fn isSafe(line: []const i32) bool {
    // 
    var isAsc = true;

    for (0..line.len-1, 1..line.len) |i, j|{
        if (j == line.len) {
            return true;
        }
        if (line[i] == line[j]) {
            return false;
        }
        if (i == 0)  {
            if (line[i] > line[j]) {
                isAsc = false;
            }
        }
        if (@abs(line[i] - line[j]) > 3) {
            return false;
        }
        if (isAsc and line[i] > line[j]) {
            return false;
        } else if (!isAsc and line[i] < line[j]) {
            return false;
        }


    }
    return true;
}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    print("Part 1: {d}\n", .{part1(arena, data) catch {return;}});
    print("Part 2: {d}\n", .{part2(arena, data) catch {return;}});
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var safe: i32 = 0;
    while (inputLines.next()) |line| {
        var nums = std.mem.tokenizeScalar(u8,  line, ' ');
        var row = std.ArrayList(i32).init(allocator);

        while (nums.next()) |num| {
            try row.append(try parseInt(i32, num, 10));
        }
        if (isSafe(row.items)) {
            safe += 1;
        }

    }
    return safe;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var safe: i32 = 0;
    while (inputLines.next()) |line| {
        var nums = std.mem.tokenizeScalar(u8,  line, ' ');
        var row = std.ArrayList(i32).init(allocator);

        while (nums.next()) |num| {
            try row.append(try parseInt(i32, num, 10));
        }
        if (isSafe(row.items)) {
            safe += 1;
        } else {
            var i: usize = 0;
            while(i < row.items.len) {
                const oldVal = row.orderedRemove(i);
                if (isSafe(row.items)) {
                    safe += 1;
                    break;
                }
                try row.insert(i, oldVal);
                i+=1;
            }
        }

    }
    return safe;
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
        \\7 6 4 2 1 2
        \\1 2 4 6 6
        \\9 7 6 2 1
        \\1 13 14 17 19
        \\18 6 4 2 1
        \\1 3 6 7 9
        \\10 12 13 16 17
        \\14 12 10 7 5 3
        \\47 49 50 52 53 54 57 59
        \\28 29 32 33 34
    ;

    try std.testing.expectEqual(5, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9

    ;

    try std.testing.expectEqual(4, try part2(arena, example_input));
}