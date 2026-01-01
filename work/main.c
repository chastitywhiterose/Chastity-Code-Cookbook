#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

#include "chaste-256.h"

int main(int argc, char *argv[])
{
 radix=16;
 int_width=1;

 Load_Register_Integer(A,3);
 Load_Register_Integer(B,5);
 
 Save_Register_Memory(A,0x30);
 Save_Register_Memory(B,0x38);


 putstring("\nRegisters\n");

 putstring("A="); putint(*A); putstring("\n");
 putstring("B="); putint(*B); putstring("\n");

 putstring("\nRAM\n");
 print_RAM();

 return 0;
}

/*

 putstring("This is the official test program for the C version of chastelib.\n");
 b=strint("100");

 putstring("Hello World!\n");
 

 while(a<b)
 {
  radix=2;
  int_width=8;
  putint(a);
  putstring(" ");
  radix=16;
  int_width=2;
  putint(a);
  putstring(" ");
  radix=10;
  int_width=3;
  putint(a);

  if(a>=0x20 && a<=0x7E)
  {
   putstring(" ");
   putchar(a);
  }

  putstring("\n");
  a+=1;
 }
  
*/
