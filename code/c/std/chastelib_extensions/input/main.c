#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chastelib.h"
#include "chastelib_input.h"

int main(int argc, char *argv[])
{
 char *s; /*character pointer local to this function for testing*/
 int i=0;
 
 radix=10;
 int_width=1;

 putstring("This program is the official test suite for the input extension of chastelib.\n");
 
 read_count=1;

 putstring("Input Test: The loop will keep reading strings you until you enter \"return\".\n");
 putstring("Or just enter a string containing only white space\n\n");
 
 while(read_count)
 {
  s=getstring();
  putstring("string ");
  putint(i);
  putstring(": \"");
  putstring(s);
  
  putstring("\" string_length: ");
  putint(read_count);
  putstring("\n");
  
  if(strcmp(s,"return")==0){break;}
  
  if(read_count==0)
  {
   putstring("End of input!\n");
  }
  
  i++;
 }
  
 return 0;
}

