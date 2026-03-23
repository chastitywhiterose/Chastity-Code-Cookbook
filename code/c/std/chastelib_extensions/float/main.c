#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "chastelib.h"
#include "chastelib_float.h"

int main(int argc, char *argv[])
{
 int a,b;
 float f;
 
 putstring("Official test for the float extension of chastelib.\n\n");
 
 radix=10;
 int_width=1;
 float_width=20;

 putstring("Multiplying by 2\n");
 
 a=0,b=32;
 f=1;
 while(a<=b)
 {
  putflt(f);
  putstring("\n");
  f*=2;
  a+=1;
 }

 return 0;
 
 putstring("\nDividing by 2\n");
 
 a=0,b=21;
 f=1;
 while(a<b)
 {
  putflt(f);
  putstring("\n");
  f/=2;
  a+=1;
 }
 

  
 return 0;
}

