#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

int main(int argc, char *argv[])
{
 FILE* fp; /*file pointer*/
 unsigned int x,y,i=0;
 int address=0;
 unsigned char int_bytes[8];
 int int_bytes_length,count=1,int_bytes_index;
 
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
  putstring("Converting decimal integer to series of hexadecimal bytes in little endian\n");
  
  int_bytes_index=0;
  x=0;
  y=i;
  while(y>0)
  {
   x=y&0xFF; /*get lowest byte of integer*/
   radix=16;
   int_width=2;
   putint(x);
   putstring(" ");
   int_bytes[int_bytes_index]=x; /*set this index to the byte value (0 to 255) that x contains*/
   int_bytes_index++; /*go to next index*/
   y>>=8; /*shift right 8 bytes*/
  }
  
  putstring("\n");
  
  
  
  /*fread(bytes,1,16,fp)*/
  
  
  
  
  
 }

 return 0;
}

