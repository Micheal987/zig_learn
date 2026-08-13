const std = @import("std");
const Foo = struct { id: i32, name: []const u8 };
pub fn run_example() void {
    const f = Foo{ .id = 10, .name = "你好世界！" };
    std.debug.print("{}\n,{s}", .{ f.id, f.name });
}
