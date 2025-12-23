/*basic powers of two program*/

fn main()
{
 let mut x=0;
 let mut a:u128=1;

 while x<=64
 {
  print!("{}\n",a);
  a+=a;
  x=x+1;
 }

}

/*
compile and run like this:

rustc main.rs && main
*/
