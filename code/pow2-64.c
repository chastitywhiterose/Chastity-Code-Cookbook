#include <stdio.h>
int main()
{
 int a=0,b=64;

 int x,y;
 #define length 1000
 int length2=20;
 char c[length];

 x=0;
 while(x<length)
 {
  c[x]=0;
  x++;
 }
 c[0]=1;

 while(a<=b)
 {
  printf("2 ^ %2d = ",a);
  a++;

  x=length2;
  while(x>0)
  {
   x--;
   printf("%d",c[x]);
  }
  printf("\n");

  y=0;
  x=0;
  while(x<=length2)
  {
   c[x]+=c[x];
   c[x]+=y;
   if(c[x]>9){y=1;c[x]-=10;}else{y=0;}
   x++;
  }
  if(c[length2]>0){length2++;}

 }
 return 0;
}