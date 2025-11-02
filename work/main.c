#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"


 
int main(int argc, char *argv[])
{
 int a=1987;

 radix=10;
 int_width=1;

 printf("This is the official test program for the C version of chastelib.\n");
 printf("I can print a number like %s using intstr.\n",intstr(a));
 
 /*or I can obtain a number from a string*/
 a=strint("2025");

 printf("Number from strint: %s\n",intstr(a));



 return 0;
}

