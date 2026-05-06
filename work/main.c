#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chastelib.h"
 
int main(int argc, char *argv[])
{
 FILE *fp; /*file pointer*/
 char *fs; /*pointer to a char array to be created*/
 char *s; /*pointer used to search through the file array*/
 char *ss,*sr; /*string search and replacement pointers*/
 int flength,count;
   
 if(argc==1)
 {
  putstr("chastext usage:\n\n");
  putstr(argv[0]);
  putstr(" filename.txt\n\n");
  
  putstr(argv[0]);
  putstr(" filename.txt string_search\n\n");

  putstr(argv[0]);
  putstr(" filename.txt string_search string_replace\n\n");
  
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
 
 /*if only the filename was given but nothing else, we will just display all characters to stdout*/
 
 if(argc==2)
 {
  fwrite(fs,1,count,stdout); /*write all the bytes*/
  return 0; /*return with no errors*/
 }

 /*next argument as start of substr*/
 if(argc>2)
 {
  ss=argv[2];
  putstr("search string: \"");
  putstr(ss);
  putstr("\"\n");

  radix=16;
  putint(count);

  s=fs;
  
  while(count>0)
  {
   s++;
   count--;
  }

 
 }
 
 
  
 putstr("\n---\nEOF\n");

 radix=16;
 putint(count);
 putstr(" bytes read\n");
 

 free(fs);

 return 0;
}

