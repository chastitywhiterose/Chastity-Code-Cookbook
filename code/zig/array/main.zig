const std = @import("std");

var a:[0x10]u8=undefined; //array of fixed size and type u8 (unsigned 8-bit integer)

var x:usize=0;
var y:usize=a.len; //set y to length of array

pub fn main() void
{

 while(x<y)
 {
  std.debug.print("a[{}]={}\n", .{x,a[x]});
  x=x+1;
 }
}
