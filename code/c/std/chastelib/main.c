#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

int main(int argc, char *argv[])
{
 int a=0,b;

 radix=16;
 int_width=1;

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
  
 return 0;
}
