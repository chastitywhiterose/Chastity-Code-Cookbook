#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chastelib.h"
 
int main(int argc, char *argv[])
{
 FILE *fp; /*file pointer*/
 char *fs; /*pointer to a char array to be created*/
 char *s,*s1;
 int flength,count;
   
 if(argc==1)
 {
  putstr("chastedog usage:\n\n");
  putstr(argv[0]);
  putstr(" filename.txt\n\n");
  
  putstr(argv[0]);
  putstr(" filename.txt string_start\n\n");

  putstr(argv[0]);
  putstr(" filename.txt string_start string_end\n\n");
  
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
  s=strstr(fs,argv[2]);
  if(s==NULL)
  {
   putstr("NULL\n\"");
   putstr(argv[2]);
   putstr("\"\ncould not be found\n---\n");
   return 1;
  }
  else
  {
   count-=s-fs; /*get difference between start of file string and where the substr was found*/
  }
 }
 
 /*next argument as end of substr*/
 if(argc>3)
 {
 
  /*
   Special case of closing bracket as argument for end string
   We use a bracket_index variable to keep track of the blocks. The idea is that we will keep searching for
   the proper end of a block according to the C programming language.
   This might be the end of a loop or even a function if applicable.
  */
  if(strcmp(argv[3],"}")==0)
  {
   int bracket_index=0;
   s1=s; /*begin search at beginning string from previous arg*/
   while(1)
   {
    if(*s1=='{'){bracket_index++;}
    if(*s1=='}')
    {
     bracket_index--;
     if(bracket_index==0){break;}
    }
    s1++;
   }
   
   count=(s1-s)+strlen(argv[3]); /*get difference between start of file string and where the substr was found*/
  }
  
  /*otherwise, just do inclusive end string*/
  else
  {
   s1=strstr(s,argv[3]);
   if(s1==NULL)
   {
    putstr("NULL\n\"");
    putstr(argv[3]);
    putstr("\"\ncould not be found\n---\n");
    return 1;
   }
   else
   {
    count=(s1-s)+strlen(argv[3]); /*get difference between start of file string and where the substr was found*/
   }
  }
  
 }

 fwrite(s,1,count,stdout); /*write all the bytes starting from the substr to the end of file*/

  
 putstr("\n---\nEOF\n");

 radix=10;
 putint(count);
 putstr(" bytes read\n");
 

 free(fs);

 return 0;
}

