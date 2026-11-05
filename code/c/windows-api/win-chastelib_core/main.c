#include <windows.h>

HANDLE stdout; /*used to store standard output handle*/

#include "win-chastelib.h"


int main(int argc, char *argv[])
{
 int a=0,b;
 
 stdout=GetStdHandle(STD_OUTPUT_HANDLE);

 radix=16;
 int_width=1;

 putstr("Official test suite for the C version of chastelib.\n");

 b=strint("100"); /*convert string to an integer*/
 if(strint_errors) /*if there are errors, print some messages and exit the program*/
 {
  putstr("Input string passed to strint function contains errors.\n");
  putstr("Please fix the invalid characters/radix and try again.\n");
  return 0;
 }
 
 while(a<b)
 {
  radix=2;
  int_width=8;
  putint(a);
  putstr(" ");
  radix=16;
  int_width=2;
  putint(a);
  putstr(" ");
  radix=10;
  int_width=3;
  putint(a);

  if(a>=0x20 && a<=0x7E)
  {
   putstr(" ");
   /*putchar(a);*/
   WriteFile(stdout,&a,1,0,0);
  }

  putstr("\n");
  a+=1;
 }
    
 ExitProcess(ERROR_SUCCESS);
}

