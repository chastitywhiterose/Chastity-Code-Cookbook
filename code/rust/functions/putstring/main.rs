fn main()
{
 let mut s:&str;

 s="My name is: ";

 putstring(s);

 s="Chastity";

 putstringln(s);

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
