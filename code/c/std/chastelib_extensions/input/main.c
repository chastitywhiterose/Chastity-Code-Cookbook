#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib_input.h"

int main(int argc, char *argv[])
{
 char *s; /*character pointer local to this function for testing*/
 radix=16;
 int_width=1;

 putstring("This program is the official test suite for the input extension of chastelib.\n");

 s=getstring();
 
 putstring(s);
  
 return 0;
}
