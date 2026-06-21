#include <stdio.h>

int main(int argc, char *argv[])
{
 int a=0x20,b=0x7F;

 while(a<b)
 {
  putchar(a);
  a+=1;
 }
 putchar('\n');
    
 return 0;
}

