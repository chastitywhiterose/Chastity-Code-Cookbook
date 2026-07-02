const std = @import("std");

const x=3; //constant x defined as 3
const y=5; //constant y defined as 5

pub fn main() void
{
 std.debug.print("Hello, World!\n", .{});
 std.debug.print("x = {}\ny = {}\n", .{x,y});
 std.debug.print("result = {}\n", .{x+y});
}