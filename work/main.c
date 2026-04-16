#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

int main(int argc, char *argv[])
{
 FILE* fp; /*file pointer*/
 int i=0;
 
 radix=10;
 
 if(argc==1)
 {
  putstring
  (
   "cintfind\n\n"
   "To open a file for reading:\n\n\tcintfind file\n\n"
   "To search that file for an integer\n\n\tcintfind file integer\n\n"
   "The integer can be any number in decimal.\n"
  );
  return 0;
 }

 if(argc>1)
 {
  fp=fopen(argv[1],"rb");
  if(fp==NULL)
  {
   printf("File \"%s\" cannot be opened.\n",argv[1]);
   return 1;
  }
  else
  {
   putstring("file \"");
   putstring(argv[1]);
   putstring("\" opened\n");
  }
 }
 
 if(argc>2)
 {
  i=strint(argv[2]);
  printf("integer \"%i\" entered as argument to search for\n",i);
 }

 return 0;
}

