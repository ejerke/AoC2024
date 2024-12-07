const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day07.txt");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    print("Part 1: {any}\n", .{part1(arena, data)});
    print("Part 2: {any}\n", .{part2(arena, data)});
}

// +, *, || (concatie)
fn calculateThese(num1: u64, opreator: usize, num2: u64) u64 {
    if (opreator == 0) {
        return num1 + num2;
    } else if (opreator == 1) {
        return num1 * num2;
    } else {
        unreachable;
    }

    return num1 + num2;
}

fn calculateTheRest(answer: u64, cumulated: u64, equation: []const u64) u64 {
    if (equation.len == 0) {
        return cumulated;
    }
    var a: u64 = 0;
    for (0..2) |operator| {
        const cumu = calculateThese(cumulated, operator, equation[0]);
        a = calculateTheRest(answer,cumu,  equation[1..equation.len]);
        if (a == answer) {
            return a;
        }
    }
    return a;
}

fn findIfPossible(equation: []const u64) bool {
    const answer = equation[0];

    // var tryIt: u64 = equation[1];
    // for (equation[2..equation.len]) |num| {
    //     tryIt = tryIt * num;
    // }
    // if (tryIt < answer) {
    //     return false;
    // }

    for (0..2) |operator| {
        const cumu = calculateThese(equation[1], operator, equation[2]);
        const a = calculateTheRest(answer,cumu,  equation[3..equation.len]);
        if (a == answer) {
            return true;
        }
    }

    return false;
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !u64 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var equations = std.ArrayList([] u64).init(allocator);
    while (inputLines.next()) |line| {
        var parts = splitSca(u8, line, ' ');
        var equation = std.ArrayList(u64).init(allocator);
        var answer = parts.next().?;
        try equation.append(try parseInt(u64, answer[0..answer.len-1], 10));

        while (parts.next()) |part| {
            try equation.append( try parseInt(u64, part, 10));
        }
        if (equation.items[0] == 36109644495 or equation.items[0] == 71836380) {
            print("{any}\n", .{equation.items});
        }
        try equations.append(equation.items);
    }

    var cumu: u64 = 0;
    var many: i32 = 0;
    for (equations.items) |equation| {
        if (findIfPossible(equation)) {
            cumu += equation[0];
            many += 1;
        }
    }

    return cumu;
}

// +, *, || (concatenate)
fn calculateThese2(num1: u64, opreator: usize, num2: u64) u64 {
    if (opreator == 0) {
        return num1 + num2;
    } else if (opreator == 1) {
        return num1 * num2;
    } else if (opreator == 2) {
        var num_digits: u64 = 10;
        var temp = num2/10;

        while (temp > 0) {
            temp /= 10;
            num_digits *= 10;
        }
        return num1 * num_digits + num2; // Concatenation
    } else {
        unreachable;
    }

    return num1 + num2;
}

fn calculateTheRest2(answer: u64, cumulated: u64, equation: []const u64) u64 {
    if (equation.len == 0) {
        return cumulated;
    }
    var a: u64 = 0;
    for (0..3) |operator| {
        const cumu = calculateThese2(cumulated, operator, equation[0]);
        a = calculateTheRest2(answer,cumu,  equation[1..equation.len]);
        if (a == answer) {
            return a;
        }
    }
    return a;
}

fn findIfPossible2(equation: []const u64) bool {
    const answer = equation[0];

    for (0..3) |operator| {
        const cumu = calculateThese2(equation[1], operator, equation[2]);
        const a = calculateTheRest2(answer,cumu,  equation[3..equation.len]);
        if (a == answer) {
            return true;
        }
    }

    return false;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !u64 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var equations = std.ArrayList([] u64).init(allocator);
    while (inputLines.next()) |line| {
        var parts = splitSca(u8, line, ' ');
        var equation = std.ArrayList(u64).init(allocator);
        var answer = parts.next().?;
        try equation.append(try parseInt(u64, answer[0..answer.len-1], 10));

        while (parts.next()) |part| {
            try equation.append( try parseInt(u64, part, 10));
        }
        if (equation.items[0] == 36109644495 or equation.items[0] == 71836380) {
            print("{any}\n", .{equation.items});
        }
        try equations.append(equation.items);
    }

    var cumu: u64 = 0;
    var many: i32 = 0;
    for (equations.items) |equation| {
        if (findIfPossible2(equation)) {
            cumu += equation[0];
            many += 1;
        }
    }

    return cumu;
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
        \\190: 10 19
        \\3267: 81 40 27
        \\83: 17 5
        \\156: 15 6
        \\7290: 6 8 6 15
        \\161011: 16 10 13
        \\192: 17 8 14
        \\21037: 9 7 18 13
        \\292: 11 6 16 20
        \\71836380: 1 17 7 710 803
        \\36109644495: 8 9 54 6 6 39 1 9 7 7 1 15
    ;

    try std.testing.expectEqual(3749+71836380+36109644495, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\190: 10 19
        \\3267: 81 40 27
        \\83: 17 5
        \\156: 15 6
        \\7290: 6 8 6 15
        \\161011: 16 10 13
        \\192: 17 8 14
        \\21037: 9 7 18 13
        \\292: 11 6 16 20
    ;

    try std.testing.expectEqual(1133, calculateThese2(11, 2, 33));
    try std.testing.expectEqual(11212133578, calculateThese2(112121, 2, 33578));
    try std.testing.expectEqual(12345, calculateThese2(12, 2, 345));
    try std.testing.expectEqual(123450, calculateThese2(12345, 2, 0));
    try std.testing.expectEqual(11387, try part2(arena, example_input));
}