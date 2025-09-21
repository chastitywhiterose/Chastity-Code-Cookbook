/*negative powers of two*/
#include <stdio.h>
#include <stdlib.h>
int main()
{
 /*most important variable: number of digits*/
 int length=64;

 char *a;
 int alength=2,x,y,temp;

 a=(char*)malloc(length*sizeof(*a));if(a==NULL){printf("Failed to create array a\n");return(1);}

 x=0;
 while(x<length)
 {
  a[x]=0;
  x++;
 }
 a[0]=1;

 while(alength<length)
 {
  printf("%i.",a[0]);

  x=1;
  while(x<alength)
  {
   printf("%d",a[x]);
   x++;
  }
  printf("\n");

  y=0;
  x=0;
  while(x<length)
  {
   if( (a[x]&1)==1 ){temp=5;}else{temp=0;} 
   a[x]>>=1;
   a[x]+=y;
   y=temp;
   x++;
  }
  if(a[alength]>0){alength++;}

 }

 if(a!=NULL){free(a); a=NULL;}

 return 0;
}
