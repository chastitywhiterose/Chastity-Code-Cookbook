const std = @import("std");

var a:usize=0;
var b:usize=0x10;



pub fn main() void
{
 putstring("Hello World!\n");

 //print all elements with a loop to see results
 a=0;
 while(a<b)
 {
  radix=2;
  int_width=8;
  std.debug.print("{s}\n", .{intstr(a)});
  a+=1;
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
var int_string: [usl+1]u8=undefined; //array of bytes of size usl+1 for terminating zero

var radix:usize=2; //radix used for integer conversion
var int_width:usize=1; //default minimum digits for printing integers

pub fn intstr(n:usize) []const u8
{
 var i:usize=n; //copy argument into this mutable variable 
 var width:usize=0; //the current width of this string start at 0 characters
 var index:usize=usl; 

 int_string[index]=0;

 while(i!=0 or width<int_width) //loop to fill the string with every required digit plus prefixed zeros
 {
  index-=1;
  int_string[index]=@truncate(i%radix);
  i/=radix;
  if(int_string[index]<10){int_string[index]+='0';}
  else{int_string[index]=int_string[index]+'A'-10;}
  width+=1;
 }

 const slice: []const u8=int_string[index..int_string.len]; //slice containing whole string
 
 return slice;
}