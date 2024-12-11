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
    print("Part 2: {any}\n", .{part2(arena, data, 5)});
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

fn part2(allocator: std.mem.Allocator, input: []const u8, timesToBlink: u8) !usize {
    // Start a loop through the lines of the input
    var inputNums = tokenizeSca(u8, input, ' ');
    var memory = std.ArrayList(u32).init(allocator);
    while (inputNums.next()) |num| {
        memory.append(try std.fmt.parseUnsigned(u32, num, 10)) catch {
            return error.Muisti;
        };
    }

    // Track each distinct number only once
    // Key is the number, value is the amount of those numbers
    var map = std.AutoHashMap(u32, u32).init(allocator);

    for (0..timesToBlink) |_| {
        memory = blink(allocator, memory) catch return error.OOM;
        // print("{any}", .{memory.items});
        var shrunk: usize = 0;
        print("{any}", .{memory.items});
        var foundThisRound = std.AutoHashMap(u32, bool).init(allocator);
        for (memory.items, 0..memory.items.len) |num, i| {
            if (!foundThisRound.contains(num)) { // Do not remove the first occurence of that number
                foundThisRound.put(num, true) catch return error.OOM;
                continue;
            }

            const value = map.get(num);
            if (value) |*val| {
                map.put(num, val.* + 1) catch return error.OOM;
                _ = memory.swapRemove(i - shrunk);
                shrunk += 1;
            } else {
                map.put(num, 1) catch return error.OOM;
            }
        }
    }

    var cumu: usize = 0;
    for (memory.items) |num| {
        const value = map.get(num);
        if (value) |*val| {
            cumu += val.*;
        } else {
            unreachable;
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
        \\125 17
    ;

    try std.testing.expectEqual(22, try part1(arena, example_input, 6));
}
