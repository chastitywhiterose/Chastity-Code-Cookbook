#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

int main(int argc, char *argv[])
{
 FILE* fp; /*file pointer*/
 unsigned int x,y,i=0;
 int address=0;
 unsigned char int_bytes[8],tmp_bytes[8];
 int int_bytes_index,int_bytes_length,count=1,matches=0;
 
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
  putstring("Converting decimal integer to series of hexadecimal bytes in little endian\n\n");
  
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
  putstring("\n\n");
  int_bytes_length=int_bytes_index;
  putstring("length of this byte array = ");
  putint(int_bytes_length);
  putstring("\n");

  putstring("Searching for matches in file\n");
  putstring("Addresses are in hexadecimal\n");
  
 while(1)
 {

  /*read the required length of bytes into a temporary byte array*/
  count=fread(tmp_bytes,1,int_bytes_length,fp);

  if(count<int_bytes_length){putstring("EOF\n");break;}

  
  x=0;
  while(x<int_bytes_length)
  {
   if(int_bytes[x]!=tmp_bytes[x])
   {
    /*putstring(" no match\n");*/
    break;
   }
   x++;
  }

  if(x==int_bytes_length)
  {
   int_width=8;
   putint(address);
   putstring(" match found!\n");
   matches++;
  }
 
  address++; /*add 1 to address*/ 

  fseek(fp,address,SEEK_SET); /*move file position to next address*/
 }
  
  radix=10;
  int_width=1;
  putstring("total matches found = ");
  putint(matches);
  putstring("\n");
  
 }

 return 0;
}

