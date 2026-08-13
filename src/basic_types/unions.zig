const std = @import("std");
const Foo = union { id: i32, name: []const u8 };
pub fn run_example() void {
    const f = Foo{ .id = 10, .name = "這個是共體" };
    std.debug.print({}, .{f});
}
