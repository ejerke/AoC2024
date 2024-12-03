const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    print("Part 1: {any}\n", .{part1(arena, data)});
    print("Part 2: {any}\n", .{part2(arena, data)});
}

fn parsePart(part: []const u8) i32 {
    const comma =  indexOf(u8, part, ',') orelse return 0;
    const closing = indexOf(u8, part, ')') orelse return 0;

    if (comma > 3 or (closing-comma) > 4) {
        return 0;
    }

    const left = parseInt(i32, part[0..comma], 10) catch {return 0;};
    const right = parseInt(i32, part[comma+1..closing], 10) catch {return 0;};

    return left*right;
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: i32 = 0;
    while (inputLines.next()) |line| {
        var possibleMul = splitSeq(u8, line, "mul(");

        while (possibleMul.next()) |part| {
            const ret = parsePart(part);
            ans += ret; 
        }
    }

    _ = allocator;
    return ans;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var ans: i32 = 0;
    var idx:usize = 0;
    var oldIdx:usize = 0;
    var do = true;
    while (idx < input.len - 1 and oldIdx < input.len - 1) {
        // FInd the index of the operator that will next change the do variable
        if (do) {
            const a = indexOfStr(u8, input, oldIdx, "don't()");
            if (a) |*value| {
                idx = value.*;
            } else {
                idx = input.len - 1;
            }
        } else {
            const a = indexOfStr(u8, input, oldIdx, "do()");
            if (a) |*value| {
                idx = value.*;
            } else {
                idx = input.len - 1;
            }
        }

        if (!do) {
            do = !do;
            oldIdx = idx;
            continue;
        }
        var possibleMul = splitSeq(u8, input[oldIdx..idx], "mul(");

        while (possibleMul.next()) |part| {
            const ret = parsePart(part);
            ans += ret; 
        }
        oldIdx = idx;

        do = !do;
    }

    _ = allocator;
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
        \\xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    ;

    try std.testing.expectEqual(161, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\laksdjlkasjd098309810923
        \\xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
        \\asd123()don't()mul(2,3)do()mul(2,1)asd981237981723
    ;

    try std.testing.expectEqual(50, try part2(arena, example_input));
}