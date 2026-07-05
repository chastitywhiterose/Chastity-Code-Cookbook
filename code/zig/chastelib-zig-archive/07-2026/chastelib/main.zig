const std = @import("std");

pub fn main() void
{
 const string0:[]const u8="Official test suite for the Zig version of chastelib.\n";
 var a:usize=0;
 var b:usize=0;

 radix=0x10; //set radix before we get input with strint   
 b=strint("100"); //convert strint to integer with strint

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


 a=strint("515");
 putint(a);
 putstr("\n");
}

//This file is a library of functions written by Chastity White Rose.
//Written for the Zig programming language

//putstr prints a string AKA u8 slice of bytes in zig
//intstr converts an integer to a string for putstr
//putint calls both functions above to print an integer
//strint converts a string to an integer

//intstr and strint are the two functions upon which the library centers
//they both use a global variable for the radix

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


//The strint_errors variable is used to keep track of how many errors happened in the strint function.
//The following errors can occur:

//Radix is not in range 2 to 36
//Character is not a number 0 to 9 or alphabet A to Z (in either case)
//Character is alphanumeric but is not valid for current radix

//If any of these errors happen, error messages are printed to let the programmer or user know what went wrong in the string that was passed to the function.
//If getting input from the keyboard, the strint_errors variable can be used in a conditional statement to tell them to try again and recall the code that grabs user input.

var strint_errors:usize=0;

//using array syntax rather than pointer syntax is required
//therefore, si is used as index to the s string

pub fn strint(s:[]const u8) usize
{
 var i:usize=0; //the integer that will be returned from this function
 var si:usize=0; //the index to the s string
 var c:u8=0;
 strint_errors = 0; //set zero errors before we parse the string
 if( radix<2 or radix>36 ){ strint_errors+=1; std.debug.print("Error: radix {} is out of range!\n",.{radix}); }
 while( s[si] == ' ' or s[si] == '\n' or s[si] == '\t' ){si+=1;} //skip whitespace at beginning
 while(si<s.len)
 {
  c=s[si];
  if( c >= '0' and c <= '9' ){c-='0';}
  else if( c >= 'A' and c <= 'Z' ){c-='A';c+=10;}
  else if( c >= 'a' and c <= 'z' ){c-='a';c+=10;}
  else if( c == ' ' or c == '\n' or c == '\t' ){break;}
  else{ strint_errors+=1; std.debug.print("Error: {c} is not an alphanumeric character!\n",.{s[si]});break;}
  if(c>=radix){ strint_errors+=1; std.debug.print("Error: {c} is not a valid character for radix {d}\n",.{s[si],radix});break;}
  i*=radix;
  i+=c;
  si+=1;
 }
 return i;
}

//One of the things I learned about Zig is that the function
//std.debug.print is basically printf for Zig
//Format specifiers
//{c} for character
//{d} for decimal integer
//{s} for string
//Therefore, it was very easy to port the C version of strint over to Zig
//It is especially relevant because strint should only print something
//if an error happened. The fact that std.debug.print goes to stderr
//is quite important to my design for this function.
//Find out more here:
//https://zig.guide/standard-library/formatting-specifiers




//a putchar function for Zig using std.debug.print
//it casts the number to a constant u8 byte named c by truncating it
//this function is useful for porting C programs that make extensive use of putchar

pub fn putchar(n:usize) void
{
 const c:u8=@truncate(n);
 std.debug.print("{c}",.{c});
}
