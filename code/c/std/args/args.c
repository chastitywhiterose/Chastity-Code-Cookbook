/*Command line arguments demo*/
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char **argv)
{
 int x=0;
 while(x<argc)
 {
  printf("argv[%i]: %s\n",x,argv[x]);
  x++;
 }
 return 0;
}
