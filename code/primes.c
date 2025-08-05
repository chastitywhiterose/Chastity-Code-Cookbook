#include <stdio.h>
int main()
{
 int x,y;
 #define length 1000
 char c[length];

 x=0;
 while(x<length)
 {
  c[x]=0;
  x++;
 }
 c[0]=1;

 printf("2 ");
 x=3;
 while(x<length)
 {
  printf("%d ",x);
  y=x;
  while(y<length)
  {
   c[y]=1;
   y+=x;
  }
  while(x<length && c[x]>0){x+=2;}
 }
 
 return 0;
}
