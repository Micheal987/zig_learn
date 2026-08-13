const std = @import("std");
const print = @import("std").debug.print;
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("=== Zig 整數類型全面進階指南 ===\n\n", .{});

    // -------------------------------------------------------------
    // 1. 標準整數與任意位元整數 (Standard & Arbitrary Bit Sized)
    // -------------------------------------------------------------
    // 格式：i(位元數) 代表有號數，u(位元數) 代表無號數
    const normal_i32: i32 = -42;
    const normal_u64: u64 = 123_456_789; // 可以用下底線分隔
    print("{}", .{normal_u64});
    // 🔥 Zig 獨家：任意位元整數（Arbitrary-bit width）
    // 你可以精準宣告符合記憶體需求的位元，這在硬體驅動或協議解析時極度好用！
    const my_u3: u3 = 7; // 3位元無號數，範圍 0 ~ 7
    const my_i7: i7 = -64; // 7位元有號數，範圍 -64 ~ 63
    const my_u24: u24 = 0xFFFFFF; // 24位元（常見於 RGB 顏色顏色值）

    try stdout.print("[1. 定義] i32: {}, u3: {}, i7: {}, u24: {}\n\n", .{ normal_i32, my_u3, my_i7, my_u24 });

    // -------------------------------------------------------------
    // 2. 編譯期整數 (Comptime Integer)
    // -------------------------------------------------------------
    // 當你寫下一個數字卻沒有給它特定型態時，它的型態是 `comptime_int`。
    // `comptime_int` 擁有無限精度，不會發生溢位，只存在於編譯期。
    const super_big = 99999999999999999999999999999999999999; // 超越 u128 限制，合法！

    // 編譯期整數在賦值給運行期變數時，會自動進行安全檢查
    const runtime_u8: u8 = 200; // 合法，因為 200 在 u8 範圍內
    // const broken_u8: u8 = 300; // ❌ 如果解開這行，編譯會報錯：300 超出 u8 範圍
    _ = super_big;
    _ = runtime_u8;

    // -------------------------------------------------------------
    // 3. 安全的顯式型態轉換 (Type Casting)
    // -------------------------------------------------------------
    // Zig 絕對不允許隱式轉型（Implicit Casting），所有轉換必須明確寫出來。
    const small_num: u8 = 100;

    // 安全拓寬轉換：小範圍轉大範圍，使用 @as
    const big_num: u16 = @as(u16, small_num);

    // 縮小轉換：大範圍轉小範圍，使用 @intCast。
    // ⚠️ 注意：如果運行期發現數值超過目標型態的容納範圍，程式會直接崩潰（Panic），確保安全。
    const large_num: u32 = 250;
    const dynamic_u8: u8 = @intCast(large_num);

    try stdout.print("[3. 轉型] u16: {}, 縮小後的 u8: {}\n\n", .{ big_num, dynamic_u8 });

    // -------------------------------------------------------------
    // 4. 溢位控制運算子 (Overflow Operators) - 極重要！
    // -------------------------------------------------------------
    // 在 Zig 中，標準的 `+`, `-`, `*` 如果發生溢位，在 Debug 模式下會觸發 Panic（崩潰）。
    // Zig 提供了特殊的運算子來決定你想要的溢位行為：

    // 👍 這裡用 var，因為我們下面真的會去改它
    var max_u8: u8 = 255;

    // 🔥 使用 +%= 直接修改 max_u8 本身的值
    max_u8 +%= 1;

    std.debug.print("修改後的 max_u8 = {}\n", .{max_u8}); // 輸出：0

    // (B) 飽和運算子 (Saturating): `+ |`, `- |`, `* |`
    // 到達邊界後，就不再改變（卡在最大/最小值）
    const sat_result = max_u8 +| 10; // 255 + 10 -> 255
    try stdout.print("[4. 溢位] 飽和運算 (+|): 255 + 10 = {}\n", .{sat_result});

    // (C) 帶溢位檢查的內建函式 (Checked Arithmetic)
    // 返回一個元組 (Tuple)，包含結果與一個布林值（是否溢位）
    const check_res = @addWithOverflow(max_u8, 1);
    try stdout.print("[4. 溢位] 檢查運算: 結果 = {}, 是否溢位 = {}\n\n", .{ check_res[0], check_res[1] });

    // -------------------------------------------------------------
    // 5. 位元運算與特殊函數 (Bitwise & Special Utilities)
    // -------------------------------------------------------------
    const bit_a: u8 = 0b10101010; // 二進位字面量
    const bit_b: u8 = 0b01010101;

    // 標準位元運算
    const and_res = bit_a & bit_b;
    const or_res = bit_a | bit_b;
    const xor_res = bit_a ^ bit_b;
    const not_res = ~bit_a;
    const shl_res = bit_a << 1; // 左移

    try stdout.print("[5. 位元] AND: 0x{x}, OR: 0x{x}, XOR: 0x{x}, NOT: 0x{x}, SHL: 0x{x}\n", .{ and_res, or_res, xor_res, not_res, shl_res });

    // 實用的標準庫整數工具
    const test_val: u32 = 0x00FFFF00;
    try stdout.print("[5. 工具] 計算二進位中 1 的數量: {}\n", .{@popCount(test_val)});
    try stdout.print("[5. 工具] 計算前方連續零的數量: {}\n", .{@clz(test_val)});
    try stdout.print("[5. 工具] 位元反轉 (Endian 轉換常用): 0x{x}\n", .{@byteSwap(test_val)});
}
