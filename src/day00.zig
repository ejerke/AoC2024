const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day00.txt");

const valid = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

fn isOneOfValid(str: []const u8) u8 {
    var number: u8 = 1;

    // Loop through the valid numbers
    for (valid) |num| {
        var i: u8 = 0;

        // Loop through the characters of that number
        for (num) |char| {

            // If i is still small enough, and we haven't found a mismatching char,
            // Continue
            if (char != str[i]) {
                break;
            }

            // End of target string without mismatches
            if (i == (num.len - 1)) {
                return number;
            }
            i += 1;
        }
        number += 1;
    }

    return 0;
}

// 1st day AoC 2023 included here as a warmup.
pub fn main() !void {
    const four = [_]u8{ 'f', 'o', 'u', 'r', 0, 0 };
    if (isOneOfValid(&four) != 4) {
        std.debug.print("ei oll", .{});
    }
    var splat = splitAny(u8, data, "\n");

    var cum: i32 = 0;
    var line = splat.next() orelse return;

    var f = true;
    while (true) {
        var leftMostFound = false;
        var first: i32 = 0;
        var second: i32 = 0;
        var i: usize = 0;
        while (i < line.len) {
            if (std.ascii.isAlphanumeric(line[i]) and !std.ascii.isAlphabetic(line[i])) { // Get the number
                if (!leftMostFound) { // First number of this line
                    first = line[i] - '0';
                    leftMostFound = true;
                }
                second = line[i] - '0';
            } else { // Loop until no longer alphabetic, or up to 5
                var possible = [_]u8{ line[i], 0, 0, 0, 0, 0 };
                var j: usize = 1;

                // j is 0-4, i+j < length of the line, and that character has to still be alphabetic
                while (j < 5 and i + j < line.len and std.ascii.isAlphabetic(line[i + j])) {

                    // Append that to the accumulated string and test for a match
                    possible[j] = line[i + j];

                    // No need to test if the string is only 2 chars long
                    if (j == 1) {
                        j += 1;
                        continue;
                    }
                    const value = isOneOfValid(&possible);
                    // std.debug.print("Trying: '{s}' -> {c}\n", .{possible, value});
                    if (value != 0) { // num found
                        if (!leftMostFound) { // It is the first one on that line
                            first = value;
                            leftMostFound = true;
                        }
                        second = value; // Found a new rightmost
                    }

                    j += 1;
                }
            }

            // Go to the next char
            i += 1;
        }
        first = first * 10;
        cum = cum + first + second;

        line = splat.next() orelse break;
        if (f) {
            f = false;
        }
    }
    print("{d}\n", .{cum});
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

test "Easy" {
    const four = [_]u8{ 'f', 'o', 'u', 'r', 0, 0 };
    try std.testing.expectEqual(isOneOfValid("nine"), 9);
    try std.testing.expectEqual(isOneOfValid(&four), 4);
    try std.testing.expectEqual(isOneOfValid("one"), 1);
}
