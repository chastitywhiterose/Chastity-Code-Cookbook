#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastebuf.h"

int main(int argc, char *argv[])
{
 int a=0,b;

 radix=16;
 int_width=1;

 putstring("This program is the official test suite for the C version of chastelib.\n");

 b=strint("100");
 
 while(a<b)
 {
  radix=2;
  int_width=8;
  bufcat(intstr(a));
  bufcat(" ");
  radix=16;
  int_width=2;
  bufcat(intstr(a));
  bufcat(" ");
  radix=10;
  int_width=3;
  bufcat(intstr(a));

  if(a>=0x20 && a<=0x7E)
  {
   bufcat(" ");
   bufchar(a);
  }

  bufcat("\n");
  a+=1;
 }
 
 bufput();
  
 return 0;
}
