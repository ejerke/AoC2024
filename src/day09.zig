const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day09.txt");
const dot: usize = 9999999;

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    // print("Part 1: {any}\n", .{part1(arena, data)});
    print("Part 2: {any}\n", .{part2(arena, data)});
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !usize {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');

    // Map the files
    var memory = std.ArrayList(usize).init(allocator);
    while (inputLines.next()) |line| {
        var i: usize = 0;
        var id: usize = 0;
        while (i < line.len) {
            var char: usize = line[i] - '0';
            if (char > 9 or char < 0) {
                char = dot;
            }
            var count: usize = 0;
            if (i % 2 == 0) {
                while (count < char) {
                    memory.append(id) catch {
                        return error.Muisti;
                    };
                    count += 1;
                }
                id += 1;
            } else {
                while (count < char) {
                    memory.append(dot) catch {
                        return error.Muisti;
                    };
                    count += 1;
                }
            }
            i += 1;
        }
    }

    // Order

    var i = memory.items.len - 1;
    while (i > 0) {
        if (memory.items[i] == dot) {
            i -= 1;
            continue;
        }

        const tmp = memory.items[i];
        var up: usize = 0;
        while (up < i) {
            if (memory.items[up] == dot) {
                memory.items[up] = tmp;
                memory.items[i] = dot;
                up += 1;
                break;
            }
            up += 1;
        }
        i -= 1;
    }

    // Calculate checksum
    i = 0;
    var cumu: usize = 0;
    while (i < memory.items.len) {
        if (memory.items[i] == dot) {
            break;
        }
        cumu += memory.items[i] * i;
        i += 1;
    }

    return cumu;
}

fn printMemory(memory: std.ArrayList(usize)) void {
    for (memory.items) |item| {
        if (item == dot) {
            print(".", .{});
        } else {
            print("{d}", .{item});
        }
    }
    print("\n", .{});
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !usize {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');

    // Map the files
    var memory = std.ArrayList(usize).init(allocator);
    while (inputLines.next()) |line| {
        var i: usize = 0;
        var id: usize = 0;
        while (i < line.len) {
            var char: usize = line[i] - '0';
            if (char > 9 or char < 0) {
                char = dot;
            }
            var count: usize = 0;
            if (i % 2 == 0) {
                while (count < char) {
                    memory.append(id) catch {
                        return error.Muisti;
                    };
                    count += 1;
                }
                id += 1;
            } else {
                while (count < char) {
                    memory.append(dot) catch {
                        return error.Muisti;
                    };
                    count += 1;
                }
            }
            i += 1;
        }
    }

    // Order

    var i = memory.items.len - 1;
    while (i > 0) {
        if (i < 5) {
            break;
        }

        if (memory.items[i] == dot) {
            i -= 1;
            continue;
        }

        // Count the size of the section
        var size: usize = 1;
        while (true) {
            if (memory.items[i - size] != memory.items[i]) {
                break;
            }
            size += 1;
        }

        const tmp = memory.items[i];
        var up: usize = 0;

        // Find a sufficiently large free space
        while (up < i - size) {
            if (memory.items[up] != dot) {
                up += 1;
                continue;
            }
            var sizeSpace: usize = 1;
            while (true) {
                if (memory.items[up] != memory.items[up + sizeSpace]) {
                    break;
                }
                sizeSpace += 1;
            }

            if (sizeSpace < size) {
                up += sizeSpace;
                continue;
            }

            // Found sufficiently large space, move

            var m: usize = 0;
            while (m < size) {
                memory.items[up + m] = tmp;
                memory.items[i - size + 1 + m] = dot;
                m += 1;
            }
            break;
        }
        i -= size;
    }

    // Calculate checksum
    i = 0;
    var cumu: usize = 0;
    while (i < memory.items.len) {
        if (memory.items[i] == dot) {
            i += 1;
            continue;
        }
        cumu += memory.items[i] * i;
        i += 1;
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
        \\2333133121414131402
    ;

    try std.testing.expectEqual(1928, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\2333133121414131402
    ;

    try std.testing.expectEqual(2858, try part2(arena, example_input));
}
