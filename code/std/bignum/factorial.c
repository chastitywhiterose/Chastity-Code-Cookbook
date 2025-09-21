/*program to generate the factorial sequence*/
#include <stdio.h>
#include <stdlib.h>
int main()
{
 /*most important variable: number of digits*/
 int length=64;
 
 char *a,*b,*c; /*pointers to arrays*/
 int alength,blength,clength; /*variable to keep track of the current length of the c array*/
 int x,ax,bx,cx,i; /* extra variables that are required for my personal multiplication system */
 
 /*allocate memory for 3 arrays of equal size AKA length*/
 a=(char*)malloc(length*sizeof(*a));if(a==NULL){printf("Failed to create array a\n");return(1);}
 b=(char*)malloc(length*sizeof(*b));if(b==NULL){printf("Failed to create array b\n");return(1);}
 c=(char*)malloc(length*sizeof(*c));if(c==NULL){printf("Failed to create array c\n");return(1);}

 /*set all digits of these arrays to zero*/
 x=0;while(x<length){a[x]=0;b[x]=0;c[x]=0;x++;}
 a[0]=1; /*set lowest digit of a array to 1*/
 b[0]=2; /*set lowest digit of b array to 2*/

 /*
  Keep track of the currently used length of each array.
  At the start, use only one digit
 */
 alength=1;
 blength=1;
 clength=1;
 
 while(clength!=length) /* main loop that repeats the process! */
 {
  /*stage 1: display the a array*/
  x=alength; while(x>0){x--;printf("%i",a[x]);} printf("\n");

  /*
   stage 2: multiply the a and b arrays together and store the result
   in the c array
  */
  bx=0;
  while(bx<blength)/*multiplication code begin*/
  {
   ax=0;
   while(ax<alength)
   {
    i=a[ax]*b[bx];
    cx=ax+bx; 
    while(cx<length && i>0)
    {
     c[cx]+=i;
     i=c[cx]/10;
     c[cx]%=10;
     cx++;
     if(cx>clength){clength=cx;}
    }
    ax++;
   }
   bx++;

  } /*multiplication code end*/



  /*stage 3: add 1 to the b array */
  i=1;
  bx=0;
  while(bx<length && i>0)
  {
   b[bx]+=i;
   i=b[bx]/10;
   b[bx]%=10;
   bx++;
  }
  if(bx>blength){blength=bx;}

  /* copy bytes of c[] to a[] then turn c to all zeroes again */
  /* then set alength to clength */
  x=0;while(x<length){a[x]=c[x];c[x]=0;x++;}alength=clength;
  
 }
 
 /*free all of the memory allocated for the three arrays*/
 if(a!=NULL){free(a); a=NULL;}
 if(b!=NULL){free(b); b=NULL;}
 if(c!=NULL){free(c); c=NULL;}
 
 return 0;
}
