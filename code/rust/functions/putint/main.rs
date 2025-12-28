/*
 chastelib: Rust edition

 The main function of this program calls the functions of chastelib. chastelib is a library of functions for integer input and output using any base from 2 to 36. It is also possible to customize the width (how many leading zeros) an integer is printed with.
*/

fn main()
{
 putstring("This program tests chastelib: Rust edition\n");
 let mut a:u32=0;
 let b=strint("100",16);
 while a<b
 {
  putint(a,2,8);
  print!(" ");
  putint(a,16,2);
  print!(" ");
  putint(a,10,3);

  if a>=0x20 && a<=0x7E
  {
   print!(" ");
   print!("{}",(a as u8) as char);
  }

  println!();
  a+=1;
 }

 println!("The chart above shows all numbers from 0 to {} in their binary,hexadecimal and decimal form.",intstr(a,10,1));
 println!("It also shows the valid printable ASCII characters where relevant. Knowing which numbers equal which characters is essential to how my integer conversion functions operate, so this list is a good reminder for me.");

}

/*
 this function returns an integer in a certain radix as a String object which can be printed with the standard print! macro.
 This makes the text output cood look more convenient but is otherwise identical to what you would get from calling the putint function directly.
 The algorithm is identical to the putstr function but it creates a string object and then pushes the characters to it with the .push method instead of printing them.
*/
fn intstr(mut i:u32,radix:u32,int_width:usize) -> String
{
 let mut s = String::new();
 let mut a: [u8;32]=[0;32]; //create array of max size needed for 32 bit integer
 let mut width=0; //keeps track of current width of integer (how many digits in the chosen radix)
 let mut r:u32; //used to store the remainder of division

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
  s.push(a[width] as char);
 }

 return s;
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

fn putint(mut i:u32,radix:u32,int_width:usize)
{
 let mut a: [u8;32]=[0;32]; //create array of max size needed for 32 bit integer
 let mut width=0; //keeps track of current width of integer (how many digits in the chosen radix)
 let mut r:u32; //used to store the remainder of division

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


/*
 this function converts a string in the specified radix into an actual integer
 Because a string can be converted into bytes with the "as_bytes()" method, I was able to get this function working identically to the way it does in the C version. Prefixing a char literal with a b turns it into a u8 byte literal. The comparisons were therefore possible with minor changes.
*/

fn strint(s:&str,radix:u32) -> u32
{
 let mut i:u32=0;
 let bytes = s.as_bytes();
 let mut x:usize=0;
 let mut c:u8;
 while x<bytes.len()
 {
  c=bytes[x];
  if c >= b'0' && c <= b'9' {c-=b'0';}
  else if c >= b'A' && c <= b'Z' {c-=b'A';c+=10;}
  else if c >= b'a' && c <= b'z' {c-=b'a';c+=10;}
  else if c == b' ' || c == b'\n' || c == b'\t' {return i;}
  else{print!("Error: {} is not an alphanumeric character!\n",c);return i;}
  if c>=radix as u8{print!("Error: {} is not a valid character for radix {}\n",c,radix);return i;}
  i*=radix;
  i+=c as u32;
  x+=1;
 }
 return i;
}

fn putstring(s:&str)
{
 print!("{}",s);
}
