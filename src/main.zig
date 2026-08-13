const std = @import("std");
const Io = std.Io;

const zig_learn = @import("zig_learn");
const enum_type = @import("basic_types/enums.zig");
const struct_type = @import("basic_types/structs.zig");
pub fn main() !void {
    enum_type.run_example();
    struct_type.run_example();
}
