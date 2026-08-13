const std = @import("std");

pub fn run_example() void {
    const msg: []const u8 = "Zig 字串就是 u8 切片！";
    std.debug.print("字串訊息: {s}\n", .{msg});
}
