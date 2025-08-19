#include <stdio.h>
int main()
{
 int a=0,b=32,c=1;
 while(a<=b)
 {
  printf("2 ^ %2d = %11d\n",a,c);
  a++;
  c+=c;
 }
 return 0;
}
