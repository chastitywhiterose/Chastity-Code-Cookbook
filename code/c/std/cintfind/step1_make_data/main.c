#include <stdio.h>

 unsigned long int v[]=
 {
  626967,
  231387329 
 };

int main(int argc, char *argv[])
{
 unsigned long int a=0,b=sizeof(v)/sizeof(*v),c;

 while(a<b)
 {
  c=v[a];
  printf("v[%lu]=%lu\n",a,c);
  a+=1;
 }
    
 return 0;
}

