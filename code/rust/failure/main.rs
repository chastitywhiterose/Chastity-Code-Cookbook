fn main()
{
 let mut s="dude fart";
 let mut a=5;

 let array:[i8;64]=[0;64];

 a+=11;

 println!("The number is {} in decimal",a);

 println!("The string is {} now",s);

 s="fart butt";

 println!("The string is {} now",s);

 println!("The array is {} now",array[1]);

 s=intstr(397);

 println!("The string is {} now",s);


}

static mut INT_STRING:&str="ass";
static mut RADIX:i32=2;
static mut INT_WIDTH:i32=1;

static mut digits: [char; 16] =['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];


fn intstr(mut i:i32) -> &'static str
{
 let mut s:String="".to_string();
 let mut width=0;
 let mut r;

 while i!=0 || width<INT_WIDTH
 {
  r=i%RADIX;
  i/=RADIX;
  s=s+"digits[r]";
  width+=1;
 }

 return INT_STRING;
}