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
  //std.debug.print("a[{}]={}\n", .{x,a[x]});
  std.debug.print("{s}\n", .{intstr(x)});
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
 
}