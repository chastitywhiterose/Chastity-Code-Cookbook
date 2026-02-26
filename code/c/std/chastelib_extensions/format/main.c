#include <stdio.h>
#include "chastelib.h"
#include "chastelib_format.h"
int main(int argc, char *argv[])
{
 int a=0,b=0x100;
 putstring("Test suite for putfmt extension of chastelib.\n");
 while(a<b)
 {
  putfmt(     "Binary=",intfmt(a, 2,8)," ");
  putfmt("Hexadecimal=",intfmt(a,16,2)," ");
  putfmt(    "Decimal=",intfmt(a,10,3),"");
  if(a>=0x20 && a<=0x7E)
  {
   putstring(" Character=");
   putchar(a);
  }
  putstring("\n");
  a+=1;
 }
 return 0;
}
