const std = @import("std");
const Color = enum { Red, Bule, Yellow, Pink };
pub fn run_example() void {
    const my_color = Color.Red;
    switch (my_color) {
        Color.Red => std.debug.print("this is Red\n", .{}),
        else => std.debug.print("UnKown\n", .{}),
    }
}
