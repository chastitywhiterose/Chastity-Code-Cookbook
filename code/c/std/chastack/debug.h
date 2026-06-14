/*
a function just for printing the stack
this is used for debugging
*/
void debug_putstack()
{
 int x=0;
 while(x<stack_length)
 {
  putstr("[");
  putint(x);
  putstr("] ");
  putint(stack[x]);
  putstr("\n");
  x++;
 }
}

void stack_address()
{
 /*display the addresses of the start of the stack and the current esp*/
 radix=16;
  
 putint((long int)stack);
 putstr("\n");

 putint((long int)esp);
 putstr("\n");
}

/*
a function used for testing the stack
it pushes, pops, and prints using the debug_putstack function
*/

int stack_demo(int argc, char **argv)
{

 /*set the radix used for integer display*/
 radix=10;
 int_width=1;

 /*set the stack pointer to where it should start*/
  esp=stack+stack_length;
  ebp=esp; /*backup address of esp to ebp*/

 push(1);  
 push(2);  
 push(4);  
 push(8);  

 push(360); /*push a wrong number to the stack*/
 pop();     /*pop it off the stack to show it is deleted*/

 push(16);  
 push(32);  
 push(64);  
 push(128);  
 
 putstr("printing the stack\n");
 debug_putstack();
 putstr("end of debug stack\n");
 
 
 while(esp<ebp)
 {
  putint(*esp);
  putstr("\n");
  esp++;
 }
 
 return 0;
}
