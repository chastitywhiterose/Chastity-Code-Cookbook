#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
 
int main(int argc, char *argv[])
{
 FILE *fp; /*file pointer*/
 char *fs; /*pointer to a char array to be created*/ 
 int flength,count;
   
 if(argc==1)
 {
  putstr("chastedog usage:\n\n");
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
 
 /*get length of the entire file by seeking to end and then back*/
 fseek(fp,0,SEEK_END); /*go to end of file*/
 flength=ftell(fp); /*get position of the file*/
 fseek(fp,0,SEEK_SET); /*go back to the beginning*/
  
 /*now we know the length of the file, we will load the whole thing*/
 fs=malloc(flength+1); /*allocate enough bytes for the whole file plus zero terminator*/
  
 count=fread(fs,1,flength,fp); /*read all the bytes*/

 fwrite(fs,1,count,stdout); /*write all the bytes*/

 putstr("\n---\nEOF\n");

 radix=10; 
 putstr("\nfile length==");
 putint(flength);
 putstr("\n");

 free(fs);

 return 0;
}

