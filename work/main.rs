fn main()
{
 let s:&str;

 s="My name is Chastity";

 putstringln(s);

 let number:i32=76;

 println!("the number is {}",number);

 putint(number,16,8);
 

}


fn putint(mut i:i32,radix:i32,int_width:usize)
{
 println!("at the beginning of the function, the number is {}",i);
 println!("the selected radix is {}",radix);

 let mut a: [i32;32]=[0;32]; //create array of max size needed for 32 bit integer
 let mut width=0; //keeps track of current width of integer (how many digits in the chosen radix)
 let mut r:i32; //used to store the remainder of division

 while i!=0 || width<int_width
 {
  r=i%radix;
  i/=radix;
  a[width]=r;
  width+=1;
 }

 while width>0
 {
  width-=1;
  if a[width]<10 { print!("{},",a[width]); }
  else {print!("{},",(char)a[width]);}
 }
 println!();

}


#[allow(dead_code)]
fn putstring(s:&str)
{
 print!("{}",s);
}

#[allow(dead_code)]
fn putstringln(s:&str)
{
 println!("{}",s);
}
