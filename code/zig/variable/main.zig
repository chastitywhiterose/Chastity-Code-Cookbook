const std = @import("std");

var x:i32=0;
var y:i32=16;

pub fn main() void
{
 while(x<y)
 {
  std.debug.print("x={}\n", .{x});
  x=x+1;
 }
}
