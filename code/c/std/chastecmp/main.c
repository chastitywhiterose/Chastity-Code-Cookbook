#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
 
int main(int argc, char *argv[])
{
 int argx,x;
 FILE* fp[3]; /*file pointers*/
 int c0=0,c1,c2;
   
 /*printf("argc=%i\n",argc);*/

 if(argc<3)
 {
  putstr("Welcome to Chastity's Hex Compare program also known as \"chastecmp\".\n\n");
  putstr("Enter two filenames as command line arguments such as:\n");
  putstr(argv[0]);
  putstr(" file1.txt file2.txt\n");
  return 0;
 }

 argx=1;
 while(argx<3)
 {
  fp[argx] = fopen(argv[argx], "rb"); /*Try to open the file.*/
  if(!fp[argx]) /*If the pointer is NULL then this becomes true and the file open has failed!*/
  {
   putstr(argv[argx]);
   putstr("\nFailed to open file\n");
   return 1;
  }
  else
  {
   putstr(argv[argx]);
   putstr(" opened\n");
  }

  argx++;
 }

  x=0;
 while(c0!=EOF)
 {
  c1 = fgetc(fp[1]);
  c2 = fgetc(fp[2]);

  if(c1==EOF){putstr(argv[1]);putstr(" EOF\n");c0=EOF;}
  if(c2==EOF){putstr(argv[2]);putstr(" EOF\n");c0=EOF;}
 
  if(c0!=EOF && c1!=c2)
  {
   printf("%08X %02X %02X\n",x,c1,c2);
  }
  x++;  
 }

 return 0;
}
