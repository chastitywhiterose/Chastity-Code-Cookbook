#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib_float.h"

int main(int argc, char *argv[])
{
 float a=1,b=16,f;
 
 putstring("Official test for the float extension of chastelib.\n");

 radix=10;
 int_width=3;
 float_width=20;
 
 while(a<=b)
 {
  putint(256);
  putstring("/");
  putint(a);
  putstring(" = ");

  f=256/a;
  /*printf("printf %0.20f ",f);*/
  putflt(f);
  putstring("\n");
  a+=1;
 }
  
 return 0;
}

