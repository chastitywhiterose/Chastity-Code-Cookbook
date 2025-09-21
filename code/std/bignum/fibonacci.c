/*program to generate the fibonacci sequence*/
#include <stdio.h>
#include <stdlib.h>
int main()
{
 /*most important variable: number of digits*/
 int length=64;
 
 char *a,*b,*c;
 int alength,x,i;
 
 /*allocate memory for 3 arrays of equal size AKA length*/
 a=(char*)malloc(length*sizeof(*a));if(a==NULL){printf("Failed to create array a\n");return(1);}
 b=(char*)malloc(length*sizeof(*b));if(b==NULL){printf("Failed to create array b\n");return(1);}
 c=(char*)malloc(length*sizeof(*c));if(c==NULL){printf("Failed to create array c\n");return(1);}
 
 /*set all digits of these arrays to zero*/
 x=0;while(x<length){a[x]=0;b[x]=0;c[x]=0;x++;}
 a[0]=1; /*set lowest digit of a array to 1*/
 
 alength=1;
 while(alength<length)
 {
  i=0;
  x=0; while(x<alength)
  {
   c[x]=a[x]+b[x];
   c[x]+=i;
   i=c[x]/10;
   c[x]%=10;
   x++;
  }
  if(i>0){c[x]=i;alength++;}
  
  x=0;while(x<length){b[x]=a[x]; a[x]=c[x];   x++;}
  x=alength; while(x>0){x--;printf("%i",a[x]);} printf("\n");
 }
 
 if(a!=NULL){free(a); a=NULL;}
 if(b!=NULL){free(b); b=NULL;}
 if(c!=NULL){free(c); c=NULL;}
 
 return 0;
}
