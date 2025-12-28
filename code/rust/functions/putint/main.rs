fn main()
{
 println!("This is a test of the putint function I wrote for the Rust programming language.");
 let mut i:i32=0;
 while i<256
 {
  putint(i,2,8);
  print!(" ");
  putint(i,16,2);
  print!(" ");
  putint(i,10,3);
  println!();
  i+=1;
 }
}

/*
 This is the putint function for printing an integer in any base from 2 to 36.
 It is the same function I wrote in C and Assembly but with some key differences for Rust.

 Rust doesn't allow global variables in "safe" mode. Therefore, the radix and the int_width must be passed to the function each time.
 I find this inefficient because usually I am just choosing one radix for the duration of the entire program.
 The width also typically stays the same unless I am doing something fancy, such as I did in chastehex.

 The first loop stores the correct ASCII numbers as unsigned bytes in an array by repeatedly dividing by the radix and converting the remainder of division into u8 (unsigned 8 bit integer) after adding the correct numbers based on the ASCII table.

 The second loop converts these ASCII numbers into the Rust (char) type and prints them in the reverse order of how they were stored.

 Most of the code in this function was required only because Rust imposes limitations on what I can do because strings are not simply mutable arrays of bytes like they are in C or Assembly. Additionally the char type is not the same as the char type in C. In C, chars are the same as 1 byte but in Rust they are actually unicode characters that are 4 bytes each.

There is probably a better way to write this function in Rust but this is the first that has worked for me. The code is nearly twice the size of the C version of this function, but it will allow me to print my integers in any radix I want as I continue to learn the Rust programming language and see if it is worth the trouble of learning.

*/

fn putint(mut i:i32,radix:i32,int_width:usize)
{
 let mut a: [u8;32]=[0;32]; //create array of max size needed for 32 bit integer
 let mut width=0; //keeps track of current width of integer (how many digits in the chosen radix)
 let mut r:i32; //used to store the remainder of division

 while i!=0 || width<int_width
 {
  r=i%radix;
  i/=radix;
  if r<10 { r+=0x30 }
  else {r+=0x37}
  a[width]=r as u8;
  width+=1;
 }

 while width>0
 {
  width-=1;
  print!("{}", a[width] as char );
 }
}
