#include <stdio.h>
#include "binlib.h"
int main()
{
 int a=1;
 while(a!=0)
 {
  printf("%s %10u\n",int_to_binary_string(a,32),a);
  a<<=1;
 }
 return 0;
}
