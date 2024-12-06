const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day05.txt");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    print("Part 1: {any}\n", .{part1(arena, data)});
    print("Part 2: {any}\n", .{part2(arena, data)});
}

// Filter away rules that contain numbers that are not in the currently inspected update
fn filterRules(allocator: Allocator, rules: std.ArrayList([]const i32), update: []const i32) !std.ArrayList([]const i32) {
    var newRules = std.ArrayList([]const i32).init(allocator);

    for (rules.items) |rule| {
        var foundLeft = false;
        var foundRight = false;
        for (update) |one| {
            
            if (rule[0] == one) {
                foundLeft = true;
            } else if (rule[1] == one) {
                foundRight = true;
            }
            
            
            if (foundLeft and foundRight) {
                newRules.append(rule) catch {return error.Pieleen;};
                break;
            }
            
        }
    }
    return newRules;
}

fn orderUpdate(allocator: Allocator, rules: std.ArrayList([]const i32), update: []const i32) !std.ArrayList(i32) {
    var lhs = std.ArrayList(i32).init(allocator);
    var rhs = std.ArrayList(i32).init(allocator);
    var middle = std.ArrayList(i32).init(allocator);

    const narrowedRules = filterRules(allocator, rules, update) catch {return error.Pieleen;};

    for (update) |num| {
        var leftRules = std.ArrayList(i32).init(allocator);
        var rightRules = std.ArrayList(i32).init(allocator);
        for (narrowedRules.items) |rule| {
            if ( rule[0] == num ) {
                leftRules.append(num) catch {return error.Muisti;};
            } else if (rule[1] == num ) {
                rightRules.append(num) catch {return error.Muisti;};
            }
        }

        if (leftRules.items.len == 0) {
            rhs.append(num) catch {return error.Muisti;};
        } else if (rightRules.items.len == 0) {
            rhs.insert(0, num) catch {return error.Muisti;};
        } else {
            middle.append(num) catch {return error.Muisti;};
        }
    }

    // Break condition

    if (middle.items.len > 1) {
        return orderUpdate(allocator, narrowedRules, middle.items) catch {return error.Hups;};
    }

    lhs.appendSlice(middle.items) catch {return error.Muisti;};
    lhs.appendSlice(rhs.items) catch {return error.Muisti;};
    return lhs;
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    var rules = std.ArrayList([]const i32).init(allocator);
    var updates = std.ArrayList([]const i32).init(allocator);
    var firstPart = true;

    // Gather the input as i32s to two lists.
    while (inputLines.next()) |line| {
        if (line[0] == ';') {
            firstPart = false;
            continue;
        }

        if (firstPart) {
            var rule = tokenizeSca(u8, line, '|');
            var helper = std.ArrayList(i32).init(allocator);
            helper.append(try parseInt(i32, rule.next().?, 10)) catch {return error.Muisti;};
            helper.append(try parseInt(i32, rule.next().?, 10)) catch {return error.Muisti;};

            rules.append(helper.items) catch {return -1;};

        } else {
            var help = tokenizeSca(u8, line, ',');
            var cumulator = std.ArrayList(i32).init(allocator);
            while (help.next()) |num| {
                cumulator.append(try parseInt(i32, num, 10)) catch {return -1;};
            }
            updates.append(cumulator.items) catch {return -1;};
        }
    }

    var corrects = std.ArrayList([]const i32).init(allocator);
    for (updates.items) |update| {
        const ans = orderUpdate(allocator, rules, update) catch {return -1;};
        if (std.mem.eql(i32, update, ans.items)) {
            corrects.append(ans.items) catch {return -1;};
        }
    }
    var cum: i32 = 0;

    for (corrects.items) |list| {
        cum += list[(list.len-1)/2];
    }

    return cum;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !i32 {
    // Start a loop through the lines of the input
    var inputLines = std.mem.tokenizeScalar(u8, input, '\n');
    while (inputLines.next()) |line| {
        _ = line;
    }

    _ = allocator;
    return 0;
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
        \\47|53
        \\97|13
        \\97|61
        \\97|47
        \\75|29
        \\61|13
        \\75|53
        \\29|13
        \\97|29
        \\53|29
        \\61|53
        \\97|53
        \\61|29
        \\47|13
        \\75|47
        \\97|75
        \\47|61
        \\75|61
        \\47|29
        \\75|13
        \\53|13
        \\;
        \\75,47,61,53,29
        \\97,61,53,29,13
        \\75,29,13
        \\75,97,47,61,53
        \\61,13,29
        \\97,13,75,29,47
    ;

    try std.testing.expectEqual(143, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\
    ;

    try std.testing.expectEqual(0, try part2(arena, example_input));
}