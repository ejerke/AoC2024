const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day08.txt");

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
    var grid = std.ArrayList([]const u8).init(allocator);
    var mappi = std.AutoHashMap(u8, [][2]usize).init(allocator);

    var i: usize = 0;
    while (inputLines.next()) |line| {
        for (line, 0..line.len) |char, j| {
            if (char == '.') {
                continue;
            }
            const help2 = [_]usize{ i, j };
            if (!mappi.contains(char)) {
                var help = std.ArrayList([2]usize).init(allocator);
                help.append(help2) catch {
                    return error.Muisti;
                };
                mappi.put(char, help.items) catch {
                    return error.Muisti;
                };
            } else {
                const insides = mappi.get(char).?;
                var help = std.ArrayList([2]usize).init(allocator);
                for (0..insides.len) |idx| {
                    help.append(insides[idx]) catch {
                        return error.Muisti;
                    };
                }
                help.append(help2) catch {
                    return error.Muisti;
                };

                mappi.put(char, help.items) catch {
                    return error.Muisti;
                };
            }
        }

        grid.append(line) catch {
            return error.Muisti;
        };
        i += 1;
    }

    var ans = std.AutoHashMap(usize, bool).init(allocator);
    var cumu: i32 = 0;

    var mapit = mappi.keyIterator();
    while (mapit.next()) |key| {
        const set = mappi.get(key.*).?;

        var ii: usize = 0;
        while (ii < set.len - 1) {
            var jj = ii + 1;
            while (jj < set.len) {
                const left = set[ii];
                const right = set[jj];

                var di: usize = 0;
                var dj: usize = 0;
                var l1: usize = 0;
                var l2: usize = 0;
                var r1: usize = 0;
                var r2: usize = 0;

                // Left always has smaller or equal x coordinate
                di = right[0] - left[0];
                if (di > left[0]) {
                    l1 = 100; // Overset rather than underset
                } else {
                    l1 = left[0] - di; // Smaller x, so reduce even more
                }
                r1 = right[0] + di; // Larger x, so add even more
                // }

                // Left has larger y coordinate
                if (left[1] > right[1]) {
                    dj = left[1] - right[1];
                    l2 = left[1] + dj; // Larger y, so add even more
                    if (dj > right[1]) {
                        r2 = 100; // Overset rather than underset
                    } else {
                        r2 = right[1] - dj; // Smaller y, so reduce even more
                    }
                } else {
                    dj = right[1] - left[1];
                    if (dj > left[1]) {
                        l2 = 100; // Overset rather than underset
                    } else {
                        l2 = left[1] - dj; // Left is smaller, so reduce even more
                    }
                    r2 = right[1] + dj; // Right is larger, so add even more
                }

                if (l1 < i and l2 < i and !ans.contains(l1 * 50 + l2)) {
                    cumu += 1;
                    ans.put(l1 * 50 + l2, true) catch {
                        return error.Muisti;
                    };
                }
                if (r1 < i and r2 < i and !ans.contains(r1 * 50 + r2)) {
                    cumu += 1;
                    ans.put(r1 * 50 + r2, true) catch {
                        return error.Muisti;
                    };
                }
                jj += 1;
            }

            ii += 1;
        }
    }

    return cumu;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var grid = std.ArrayList([]const u8).init(allocator);
    var mappi = std.AutoHashMap(u8, [][2]usize).init(allocator);

    var i: usize = 0;
    while (inputLines.next()) |line| {
        for (line, 0..line.len) |char, j| {
            if (char == '.') {
                continue;
            }
            const help2 = [_]usize{ i, j };
            if (!mappi.contains(char)) {
                var help = std.ArrayList([2]usize).init(allocator);
                help.append(help2) catch {
                    return error.Muisti;
                };
                mappi.put(char, help.items) catch {
                    return error.Muisti;
                };
            } else {
                const insides = mappi.get(char).?;
                var help = std.ArrayList([2]usize).init(allocator);
                for (0..insides.len) |idx| {
                    help.append(insides[idx]) catch {
                        return error.Muisti;
                    };
                }
                help.append(help2) catch {
                    return error.Muisti;
                };

                mappi.put(char, help.items) catch {
                    return error.Muisti;
                };
            }
        }

        grid.append(line) catch {
            return error.Muisti;
        };
        i += 1;
    }

    var ans = std.AutoHashMap(usize, bool).init(allocator);
    var cumu: i32 = 0;

    var mapit = mappi.keyIterator();
    while (mapit.next()) |key| {
        const set = mappi.get(key.*).?;

        var ii: usize = 0;
        while (ii < set.len - 1) {
            var jj = ii + 1;
            while (jj < set.len) {
                const left = set[ii];
                const right = set[jj];

                var di: usize = 0;
                var dj: usize = 0;
                var l1: usize = 0;
                var l2: usize = 0;
                var r1: usize = 0;
                var r2: usize = 0;

                // left always has smaller x coordinate
                di = right[0] - left[0];
                if (di > left[0]) {
                    l1 = 100; // Overset rather than underset
                } else {
                    l1 = left[0] - di; // Smaller x, so reduce even more
                }
                r1 = right[0] + di; // Larger x, so add even more

                // Left has larger y coordinate
                if (left[1] > right[1]) {
                    dj = left[1] - right[1];
                    l2 = left[1] + dj; // Larger y, so add even more
                    if (dj > right[1]) {
                        r2 = 100; // Overset rather than underset
                    } else {
                        r2 = right[1] - dj; // Smaller y, so reduce even more
                    }
                } else {
                    dj = right[1] - left[1];
                    if (dj > left[1]) {
                        l2 = 100; // Overset rather than underset
                    } else {
                        l2 = left[1] - dj; // Left is smaller, so reduce even more
                    }
                    r2 = right[1] + dj; // Right is larger, so add even more
                }

                if (left[1] > right[1]) { // left has larger Y
                    var countX: usize = left[0];
                    var countY: usize = left[1];
                    //
                    // Iterate to the negative direction first
                    while (countX < i and countY >= 0) {
                        if (countX < i and countY < i and !ans.contains(countX * 50 + countY)) {
                            cumu += 1;

                            ans.put(countX * 50 + countY, true) catch {
                                return error.Muisti;
                            };
                        }

                        if (countY < dj) {
                            break;
                        }
                        countY -= dj;
                        countX += di;
                    }

                    // Iterate to the positive direction first
                    countX = left[0];
                    countY = left[1];
                    while (countX >= 0 and countY < i) {
                        if (countX < i and countY < i and !ans.contains(countX * 50 + countY)) {
                            cumu += 1;
                            ans.put(countX * 50 + countY, true) catch {
                                return error.Muisti;
                            };
                        }
                        if (countX < di) {
                            break;
                        }
                        countY += dj;
                        countX -= di;
                    }
                } else {
                    var countX: usize = left[0];
                    var countY: usize = left[1];
                    //
                    // Iterate to the negative direction first
                    while (countX >= 0 and countY >= 0) {
                        if (countX < i and countY < i and !ans.contains(countX * 50 + countY)) {
                            cumu += 1;
                            ans.put(countX * 50 + countY, true) catch {
                                return error.Muisti;
                            };
                        }
                        if (countY < dj or countX < di) {
                            break;
                        }
                        countY -= dj;
                        countX -= di;
                    }
                    countX = left[0];
                    countY = left[1];
                    //
                    // Iterate to the positive direction
                    while (countX < i and countY < i) {
                        if (countX < i and countY < i and !ans.contains(countX * 50 + countY)) {
                            cumu += 1;
                            ans.put(countX * 50 + countY, true) catch {
                                return error.Muisti;
                            };
                        }
                        countY += dj;
                        countX += di;
                    }
                }

                jj += 1;
            }

            ii += 1;
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
        \\............
        \\........0...
        \\.....0......
        \\.......0....
        \\....0.......
        \\......A.....
        \\............
        \\............
        \\........A...
        \\.........A..
        \\............
        \\............
    ;

    try std.testing.expectEqual(14, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\............
        \\........0...
        \\.....0......
        \\.......0....
        \\....0.......
        \\......A.....
        \\............
        \\............
        \\........A...
        \\.........A..
        \\............
        \\............
    ;

    try std.testing.expectEqual(34, try part2(arena, example_input));
}
