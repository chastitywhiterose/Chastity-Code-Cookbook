#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
 
int main(int argc, char *argv[])
{
 FILE* fp; /*file pointers*/
 int c=0;
   
 if(argc==1)
 {
  putstr("chastecat usage:\n\n");
  putstr(argv[0]);
  putstr(" filename.txt\n");
  return 0;
 }

 if(argc>1)
 {
  fp=fopen(argv[1],"rb");
  if(fp==NULL)
  {
   putstr(argv[1]);
   putstr("\nFailed to open file\n");
   return 1;
  }
  else
  {
   putstr(argv[1]);
   putstr("\n---\n");
  }
 }

 while((c=fgetc(fp))!=EOF)
 {
  fputc(c,stdout);
 
 }
 putstr("\n---\nEOF\n");
 
 fclose(fp);

 return 0;
}

