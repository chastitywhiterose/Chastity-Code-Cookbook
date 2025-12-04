#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "bitlib.h"
int main(int argc, char *argv[])
{
 int a;

 radix=10;
 int_width=1;

 a=1987;

 a=add(a,38);
 printf("%s\n",intstr(a));

 a=sub(a,38);
 printf("%s\n",intstr(a));

 a=mul(9,8);
 printf("%s\n",intstr(a));

 
 return 0;
}
