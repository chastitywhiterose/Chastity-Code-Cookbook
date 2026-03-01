#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib_float.h"

int main(int argc, char *argv[])
{
 float a=1,b=16,f;

radix=10;
 
 while(a<b)
 {
  f=256/a;
  printf("%f",f);
  putstring(" ");
  putstring(fltstr(f));
  putstring("\n");


  a+=1;
 }
  
 return 0;
}
