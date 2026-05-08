#include <stdio.h>
#include "chastelib.h"
int main(int argc, char **argv)
{
 int x=1;
 while(x!=argc)
 {
  putstr(argv[x]);
  putstr("\n");
  x++;
 }
 return 0;
}

/* print all command line arguments on a separate line */

