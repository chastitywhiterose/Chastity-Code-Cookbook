#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chastelib.h"
 
int main(int argc, char *argv[])
{
 FILE *fp; /*file pointer*/
 char *fs; /*pointer to a char array to be created*/
 char *s;
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
 
 /*if only the filename was given but nothing else, we will just display all characters to stdout*/
 
 if(argc==2)
 {
  fwrite(fs,1,count,stdout); /*write all the bytes*/
 }

 if(argc>2)
 {
  s=strstr(fs,argv[2]);
  if(s==NULL)
  {
   putstr("NULL\n\"");
   putstr(argv[2]);
   putstr("\"\ncould not be found in this file");
  }
  else
  {
   count-=s-fs; /*get difference between start of file string and where the substr was found*/
   fwrite(s,1,count,stdout); /*write all the bytes starting from the substr to the end of file*/
  }

 }
 
 putstr("\n---\nEOF\n");

 radix=10;
 putint(count);
 putstr(" bytes read\n");

 free(fs);

 return 0;
}

