#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
int main(int argc, char *argv[])
{
 int a=1987;

 radix=10;
 int_width=1;

 putstring("This is the official test program for the C version of chastelib.\n");
 putstring("I can print numbers using intstr,%s,and printf.\n");
 printf("String from intstr: %s\n",intstr(a));
 
 putstring("I can also turn any string into a number with strint\n");
 a=strint("2025");
 printf("Number from strint: %s\n",intstr(a));

 putstring("Hello World!\n");

 putstring("And I can even avoid using printf entirely!\n");
 a=8086;
 putint(a);
 putstring("\n");

 return 0;
}
