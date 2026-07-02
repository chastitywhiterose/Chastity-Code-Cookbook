const std = @import("std");

var a:[0x10]u8=undefined; //array of fixed size and type u8 (unsigned 8-bit integer)

var x:usize=0;
var y:usize=a.len; //set y to length of array

pub fn main() void
{

 //set all elements of array to 0 with a loop
 x=0;
 while(x<y)
 {
  a[x]=0;
  x+=1;
 }

 a[4]=8; //set this index to 8

 //print all elements with a loop to see results
 x=0;
 while(x<y)
 {
  std.debug.print("a[{}]={}\n", .{x,a[x]});
  x=x+1;
 }
}
