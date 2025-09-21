#include <stdio.h>
#include <stdlib.h>
int main()
{
 /*most important variable: number of digits*/
 int length=64;


 char *a;
 int alength=1,x,y;

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

  x=alength;
  while(x>0)
  {
   x--;
   printf("%d",a[x]);
  }
  printf("\n");

  y=0;
  x=0;
  while(x<=alength)
  {
   a[x]+=a[x];
   a[x]+=y;
   if(a[x]>9){y=1;a[x]-=10;}else{y=0;}
   x++;
  }
  if(a[alength]>0){alength++;}

 }

 if(a!=NULL){free(a); a=NULL;}

 return 0;
}
