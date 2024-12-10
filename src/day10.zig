const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day10.txt");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    print("Part 1: {any}\n", .{part1(arena, data)});
    print("Part 2: {any}\n", .{part2(arena, data)});
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var memory = std.ArrayList([]const u8).init(allocator);
    var starts = std.ArrayList([2]u8).init(allocator);
    var i: u8 = 0;
    while (inputLines.next()) |line| {
        memory.append(line) catch {
            return error.Muisti;
        };

        var j: u8 = 0;
        for (line) |char| {
            if (char == '0') {
                const helper = [_]u8{ i, j };
                starts.append(helper) catch {
                    return error.Muisti;
                };
            }
            j += 1;
        }
        i += 1;
    }

    // Find the number of different 9's reachable from each trailhead.
    var cumu: i32 = 0;
    for (starts.items) |start| {
        const help = findScore(allocator, memory, start[0], start[1]) catch {
            return error.Muisti;
        };
        // Single trailhead. Make sure same nine won't be counted here twice
        var nines = std.AutoHashMap(u16, bool).init(allocator);
        for (help) |nine| {
            if (nines.contains(@as(u16, nine[0]) * 50 + nine[1])) {
                continue;
            } else {
                nines.put(@as(u16, nine[0]) * 50 + nine[1], true) catch {
                    return error.Muisti;
                };
                cumu += 1;
            }
        }
        nines.deinit();
    }

    return cumu;
}

fn findScore(allocator: Allocator, memory: std.ArrayList([]const u8), begi: u8, begj: u8) ![][]u8 {
    var cumu = std.ArrayList([]u8).init(allocator);
    // Up
    if (begi > 0 and memory.items[begi][begj] + 1 == memory.items[begi - 1][begj]) {
        if (memory.items[begi - 1][begj] == '9') {
            var help = std.ArrayList(u8).init(allocator);
            help.append(begi - 1) catch {
                return error.Muisti;
            };
            help.append(begj) catch {
                return error.Muisti;
            };
            cumu.append(help.items) catch {
                return error.Muisti;
            };
        } else {
            const ret = findScore(allocator, memory, begi - 1, begj) catch {
                return error.Muisti;
            };
            for (ret) |one| {
                cumu.append(one) catch {
                    return error.Muisti;
                };
            }
        }
    }

    // Right
    if (begj < memory.items[begi].len - 1 and memory.items[begi][begj] + 1 == memory.items[begi][begj + 1]) {
        if (memory.items[begi][begj + 1] == '9') {
            var help = std.ArrayList(u8).init(allocator);
            help.append(begi) catch {
                return error.Muisti;
            };
            help.append(begj + 1) catch {
                return error.Muisti;
            };
            cumu.append(help.items) catch {
                return error.Muisti;
            };
        } else {
            const ret = findScore(allocator, memory, begi, begj + 1) catch {
                return error.Muisti;
            };
            for (ret) |one| {
                cumu.append(one) catch {
                    return error.Muisti;
                };
            }
        }
    }

    // Down
    if (begi < memory.items.len - 1 and memory.items[begi][begj] + 1 == memory.items[begi + 1][begj]) {
        if (memory.items[begi + 1][begj] == '9') {
            var help = std.ArrayList(u8).init(allocator);
            help.append(begi + 1) catch {
                return error.Muisti;
            };
            help.append(begj) catch {
                return error.Muisti;
            };
            cumu.append(help.items) catch {
                return error.Muisti;
            };
        } else {
            const ret = findScore(allocator, memory, begi + 1, begj) catch {
                return error.Muisti;
            };
            for (ret) |one| {
                cumu.append(one) catch {
                    return error.Muisti;
                };
            }
        }
    }

    // Left
    if (begj > 0 and memory.items[begi][begj] + 1 == memory.items[begi][begj - 1]) {
        if (memory.items[begi][begj - 1] == '9') {
            var help = std.ArrayList(u8).init(allocator);
            help.append(begi) catch {
                return error.Muisti;
            };
            help.append(begj - 1) catch {
                return error.Muisti;
            };
            cumu.append(help.items) catch {
                return error.Muisti;
            };
        } else {
            const ret = findScore(allocator, memory, begi, begj - 1) catch {
                return error.Muisti;
            };
            for (ret) |one| {
                cumu.append(one) catch {
                    return error.Muisti;
                };
            }
        }
    }

    return cumu.items;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var memory = std.ArrayList([]const u8).init(allocator);
    var starts = std.ArrayList([2]u8).init(allocator);
    var i: u8 = 0;
    while (inputLines.next()) |line| {
        memory.append(line) catch {
            return error.Muisti;
        };

        var j: u8 = 0;
        for (line) |char| {
            if (char == '0') {
                const helper = [_]u8{ i, j };
                starts.append(helper) catch {
                    return error.Muisti;
                };
            }
            j += 1;
        }
        i += 1;
    }

    // Find the number of different 9's reachable from each trailhead.
    var cumu: i32 = 0;
    for (starts.items) |start| {
        const help = findScore(allocator, memory, start[0], start[1]) catch {
            return error.Muisti;
        };
        // Single trailhead. Make sure same nine won't be counted here twice
        // var nines = std.AutoHashMap(u16, bool).init(allocator);
        for (help) |_| {
            cumu += 1;
            // if (nines.contains(@as(u16, nine[0]) * 50 + nine[1])) {
            //     continue;
            // } else {
            //     nines.put(@as(u16, nine[0]) * 50 + nine[1], true) catch {
            //         return error.Muisti;
            //     };
            // }
        }
        // nines.deinit();
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
        \\89010123
        \\78121874
        \\87430965
        \\96549874
        \\45678903
        \\32019012
        \\01329801
        \\10456732
    ;

    try std.testing.expectEqual(36, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\012345
        \\123456
        \\234567
        \\345678
        \\4.6789
        \\56789.
    ;

    try std.testing.expectEqual(227, try part2(arena, example_input));
}
