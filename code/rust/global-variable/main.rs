static mut GLOBAL: i32 = 0;

fn main()
{
 unsafe
 {
  GLOBAL = 42;
  println!("Global: {}", GLOBAL);
 }
}
