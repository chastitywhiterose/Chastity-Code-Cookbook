#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

int main(int argc, char *argv[])
{
 int a=0,b;

 radix=16;
 int_width=1;

 putstring("Official test suite for the C version of chastelib.\n");

 b=strint("100"); /*convert string to an integer*/
 if(strint_errors) /*if there are errors, print some messages and exit the program*/
 {
  putstring("Input string passed to strint function contains errors.\n");
  putstring("Please fix the invalid characters/radix and try again.\n");
  return 0;
 }
 
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

