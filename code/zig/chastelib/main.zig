const std = @import("std");

var a:[0x10]u8=undefined; //array of fixed size and type u8 (unsigned 8-bit integer)

var x:usize=0;
var y:usize=a.len; //set y to length of array

pub fn main() void
{
 putstring("Hello World!\n");

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

//putstring prints a string to standard output
//it uses the std.debug.print function
//a special slice is used in this just to show the syntax of creating a slice
//this is important for other functions but here I am just showing off

pub fn putstring(s:[]const u8) void
{
 const slice: []const u8=s[0..s.len]; //slice containing whole string
 std.debug.print("{s}",.{slice});
}

const usl=0x100; //Universal String Length
var int_string: [usl]u8=undefined;

pub fn intstr() []const u8
{
 
}