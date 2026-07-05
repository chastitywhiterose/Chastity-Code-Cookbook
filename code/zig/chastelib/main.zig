const std = @import("std");

pub fn main() void
{
 const string0:[]const u8="Official test suite for the Zig version of chastelib.\n";
 var a:usize=0;
 const b:usize=0x100;

 putstr(string0);
 a=0;
 while(a<b)
 {
  radix=2;
  int_width=8;
  putint(a);
  putstr(" ");
  radix=16;
  int_width=2;
  putint(a);
  putstr(" ");
  radix=10;
  int_width=3;
  putint(a);

  if(a>=0x20 and a<=0x7E)
  {
   putstr(" ");
   putchar(a);
  }

  putstr("\n");
  a+=1;
 }
 putstr(string0);
}

//putstr prints a string to standard output
//it uses the std.debug.print function
//a special slice is used in this just to show the syntax of creating a slice
//this is important for other functions but here I am just showing off

pub fn putstr(s:[]const u8) void
{
 const slice: []const u8=s[0..s.len]; //slice containing whole string
 std.debug.print("{s}",.{slice});
}

//the intstr function is coming next but first we need several global variables that control the output

const usl=0x100; //Universal String Length
var int_string: [usl+1]u8=undefined; //array of bytes of size usl+1 for terminating zero

var radix:usize=2; //radix used for integer conversion
var int_width:usize=1; //default minimum digits for printing integers

//This function is written to match the same algorithm as my C version
//Therefore, it adds one extra zero byte to the string
//This could make a difference if it were passed to a C function
//but is not required for zig because we only pass the slice
//also, function arguments are immutable by default in Zig
//that is why it is required to copy n to mutable i variable

pub fn intstr(n:usize) []const u8
{
 var i:usize=n; //copy argument into this mutable variable 
 var width:usize=0; //the current width of this string start at 0 characters
 var index:usize=usl; 
 int_string[index]=0; //zero terminator not required by Zig but is for C code

 while(i!=0 or width<int_width) //loop to fill the string with every required digit plus prefixed zeros
 {
  index-=1;
  int_string[index]=@truncate(i%radix);
  i/=radix;
  if(int_string[index]<10){int_string[index]+='0';}
  else{int_string[index]=int_string[index]+'A'-10;}
  width+=1;
 }

 //create a slice containing only bytes we have written to
 const slice: []const u8=int_string[index..usl];
 
 return slice;
}


//putint uses the intstr to convert an integer to a byte slice (what zig calls strings)
//then it passes it to putstr to print this slice to standard output

pub fn putint(n:usize) void
{
 putstr(intstr(n));
}

//a putchar function for Zig using std.debug.print
//it casts the number to a constant u8 byte named c by truncating it
//this function is useful for porting C programs that make extensive use of putchar

pub fn putchar(n:usize) void
{
 const c:u8=@truncate(n);
 std.debug.print("{c}",.{c});
}
