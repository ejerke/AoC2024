const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data: []const u8 = @embedFile("data/day01.txt");

pub fn main() !void {

    // Allocate some stuff
    var left = std.ArrayList(i32).init(gpa);
    left.deinit();
    var right = std.ArrayList(i32).init(gpa);
    right.deinit();

    // Gather all the numbers into left and right
    var splat = splitSca(u8, data, '\n');
    while (splat.next()) |line| {
        try left.append(try std.fmt.parseInt(i32,line[0..5], 10));
        try right.append(try std.fmt.parseInt(i32,line[8..13], 10));
    }

    std.mem.sort(i32, left.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, right.items, {}, std.sort.asc(i32));

    
    var cum: i64 = 0;
    for (left.items, right.items) |l, r| {
        cum += @abs(l-r);
    }
    print("part1: {d}\n", .{cum});

    var part2: i64 = 0;
    for (left.items) |i| {
        var count: i32 = 0;
        for (right.items) |j| {
            if (i == j) {
                print("sama {d} {d}\n", .{i, j});
                count += 1;
            }
        }
        part2 += i * count;
    }
    print("part2: {d}\n", .{part2});
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
