#include <stdio.h>
#include "binlib.h"
int main()
{
 int a=0;
 while(a<16)
 {
  printf("%s %02d\n",int_to_binary_string(a,4),a);
  a++;
 }
 return 0;
}
