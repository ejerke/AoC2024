const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day11.txt");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    // print("Part 1: {any}\n", .{part1(arena, data, 25)});
    print("Part 2: {any}\n", .{part2(arena, data, 75)});
}

fn part1(allocator: std.mem.Allocator, input: []const u8, timesToBlink: u8) !usize {
    // Start a loop through the lines of the input
    var inputNums = tokenizeSca(u8, input, ' ');
    var memory = std.ArrayList(u32).init(allocator);
    while (inputNums.next()) |num| {
        memory.append(try std.fmt.parseUnsigned(u32, num, 10)) catch {
            return error.Muisti;
        };
    }

    for (0..timesToBlink) |_| {
        memory = blink(allocator, memory) catch return error.OOM;
    }

    return memory.items.len;
}

fn blink(allocator: Allocator, memory: std.ArrayList(u32)) !std.ArrayList(u32) {
    var newMem = std.ArrayList(u32).init(allocator);

    for (memory.items) |num| {
        const txt = std.fmt.allocPrint(allocator, "{d}", .{num}) catch return error.OutOfMemory_usizeToStr;
        if (num == 0) {
            newMem.append(1) catch {
                return error.Muisti;
            };
        } else if (@mod(txt.len, 2) == 0) {
            newMem.append(try std.fmt.parseUnsigned(u32, txt[0 .. txt.len / 2], 10)) catch return error.OOM;
            newMem.append(try std.fmt.parseUnsigned(u32, txt[txt.len / 2 .. txt.len], 10)) catch return error.OOM;
        } else {
            newMem.append(num * 2024) catch return error.OOM;
        }
    }
    memory.deinit();
    return newMem;
}

fn blink2(allocator: Allocator, memory: std.AutoHashMap(u64, u64)) !std.AutoHashMap(u64, u64) {
    var newMem = std.AutoHashMap(u64, u64).init(allocator);
    var mapit = memory.keyIterator();
    while (mapit.next()) |num| {
        const txt = std.fmt.allocPrint(allocator, "{d}", .{num.*}) catch return error.OutOfMemory_usizeToStr;
        const help = memory.get(num.*);
        var oldVal: u64 = 0;
        if (help) |*val| {
            oldVal = val.*;
        } else {
            unreachable;
        }

        if (num.* == 0) {
            const new: u64 = num.* + 1;

            const value = newMem.get(new);
            if (value) |*val| {
                newMem.put(new, val.* + oldVal) catch return error.OOM;
            } else {
                newMem.put(new, oldVal) catch return error.OOM;
            }
        } else if (@mod(txt.len, 2) == 0) {
            const left = try std.fmt.parseUnsigned(u64, txt[0 .. txt.len / 2], 10);
            const right = try std.fmt.parseUnsigned(u64, txt[txt.len / 2 .. txt.len], 10);
            // print("-{d}-", .{left});
            // print("_{d}_", .{right});
            // print(" ''{d}'' ", .{oldVal});

            // if (left == right) { // If the left and right are the same, combine the operation so that the old value isn't counted twice
            //     var value = newMem.get(left);
            //     if (value) |*val| {
            //         newMem.put(left, val.* + oldVal + 2) catch return error.OOM;
            //     } else {
            //         newMem.put(left, oldVal + 2) catch return error.OOM;
            //     }
            // } else {
            var value = newMem.get(left);
            if (value) |*val| {
                newMem.put(left, val.* + oldVal) catch return error.OOM;
            } else {
                newMem.put(left, oldVal) catch return error.OOM;
            }
            value = newMem.get(right);
            if (value) |*val| {
                // print("there was {d}--{d}--", .{ right, val.* });
                newMem.put(right, val.* + oldVal) catch return error.OOM;
            } else {
                newMem.put(right, oldVal) catch return error.OOM;
            }
            // }
        } else {
            const new: u64 = num.* * 2024;

            const value = newMem.get(new);
            if (value) |*val| {
                newMem.put(new, val.* + oldVal) catch return error.OOM;
            } else {
                newMem.put(new, oldVal) catch return error.OOM;
            }
        }
    }
    return newMem;
}

fn part2(allocator: std.mem.Allocator, input: []const u8, timesToBlink: u8) !usize {
    // Start a loop through the lines of the input
    var inputNums = tokenizeSca(u8, input, ' ');
    var map = std.AutoHashMap(u64, u64).init(allocator);
    while (inputNums.next()) |num| {
        map.put(try std.fmt.parseUnsigned(u64, num, 10), 1) catch {
            return error.Muisti;
        };
    }

    // Track each distinct number only once
    // Key is the number, value is the amount of those numbers

    for (0..timesToBlink) |_| {
        map = blink2(allocator, map) catch return error.OOM;
    }

    var cumu: usize = 0;
    var mapit = map.valueIterator();
    while (mapit.next()) |num| {
        cumu += num.*;
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
        \\125 17
    ;

    try std.testing.expectEqual(22, try part1(arena, example_input, 6));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input2 =
        \\2024
    ;

    try std.testing.expectEqual(4, try part2(arena, example_input2, 2));

    const example_input3 =
        \\9999
    ;

    try std.testing.expectEqual(4, try part2(arena, example_input3, 2));

    const example_input =
        \\125 17
    ;

    try std.testing.expectEqual(22, try part2(arena, example_input, 6));
    try std.testing.expectEqual(55312, try part2(arena, example_input, 25));
}
