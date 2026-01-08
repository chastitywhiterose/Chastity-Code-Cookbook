/*Command line arguments demo*/
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char **argv)
{
 int x;
 char *default_message="Run this program with arguments to display them to the console.";

 if(argc==1)
 {
  printf("default: %s\n",default_message);
  return 0;
 }

 x=0;
 while(x<argc)
 {
  printf("argv[%i]: %s\n",x,argv[x]);
  x++;
 }

 return 0;
}
