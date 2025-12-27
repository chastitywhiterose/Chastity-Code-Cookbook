fn main()
{
 let mut s:&str="dude fart";
 let mut a=5;

 let array:[i8;64]=[0;64];

 a+=11;

 println!("The number is {} in decimal",a);

 println!("The string is {} now",s);

 s="fart butt";

 println!("The string is {} now",s);

 println!("The first element of the array is {} now",array[0]);



 println!("The string is {} now",s);

 putstring(s);

putstring("ass");


}

fn putstring(s:&str)
{
 println!("{s}");
}