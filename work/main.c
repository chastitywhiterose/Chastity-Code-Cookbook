#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "chastelib.h"

int main(int argc, char *argv[])
{
 /*int v[]={};*/
 int64_t a=0,b=38,c=1;

 radix=10;
 int_width=1;


 while(a<b)
 {
  putint(c);
  putstr(",\n");
  c=c+c;
  a+=1;
 }
    
 return 0;
}

