/*powers of two program using array as decimal digits!*/

fn main()
{
 let mut x;
 let length=64;
 let mut length1=1;
 let mut a=[0;256]; //array with 256 elements, all 0s.
 a[0]=1; //set first element to 1

 let mut x1=0;
 while x1<=64
 {
  x=length;
  while x>0
  {
   x-=1;
   print!("{}",a[x]);
  }
  print!("\n");
  let mut c=0;
  x=0;
  while x<=length1
  {
   a[x]+=a[x]; //Add this digit to itself!
   a[x]+=c;    //Add the carry!
   if a[x]>9 {c=1;a[x]-=10;}else{c=0;}
   x+=1;
  }
  if a[length1]>0 {length1+=1;}
  x1+=1;
 }
}
/*
 compile and run like this:
 rustc main.rs && main
*/
