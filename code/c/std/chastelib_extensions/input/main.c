#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chastelib.h"
#include "chastelib_input.h"

int main(int argc, char *argv[])
{
 char *s; /*character pointer local to this function for testing*/
 int i=0;
 
 radix=2;
 int_width=8;

 putstring("This program is the official test suite for the input extension of chastelib.\n");
 
 putstring("Test 0: Enter a string of some kind. Anything you like!\n");
 s=getstring();
 
 putstring("The string you entered is: ");
 putstring(s);
 putstring("\n");
 
 putstring("Length of the string : ");
 putint(read_count);
 putstring("\n");

 putstring("Test 1: The next loop will keep reading strings you until you enter \"return\".\n");
 
 while(1)
 {
  s=getstring();
  putstring("token ");
  putint(i);
  putstring(": ");
  putstring(s);
  putstring("\n");
  if(strcmp(s,"return")==0){break;}
  i++;
 }
  
 return 0;
}

