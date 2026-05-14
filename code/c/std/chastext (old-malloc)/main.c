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
 int sslength;
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
 }
 
 /*get length of the entire file by seeking to end and then back*/
 fseek(fp,0,SEEK_END); /*go to end of file*/
 flength=ftell(fp); /*get position of the file*/
 fseek(fp,0,SEEK_SET); /*go back to the beginning*/
  
 /*now we know the length of the file, we will load the whole thing*/
 fs=malloc(flength+1); /*allocate enough bytes for the whole file plus zero terminator*/
  
 count=fread(fs,1,flength,fp); /*read all the bytes*/
 
 /*
 now that all the bytes are read into memory, close the file
 */
 fclose(fp);
 
 /*if only the filename was given but nothing else, we will just display all characters to stdout*/
 
 if(argc==2)
 {
  fwrite(fs,1,count,stdout); /*write all the bytes*/
  return 0; /*return with no errors*/
 }
 
 /*if 4 or more arguments are present, use the 4th arg as the replacement string*/
 if(argc>3)
 {
  sr=argv[3];
 }

 /*
 if only a search string is given, display the whole file except also quote parts that match the search string
 this is a good way to prove that the program is correctly finding them
 
 but if a replacement string was provided, then this section will replace the search string with the replacement
 */
 
 if(argc>2)
 {
  ss=argv[2];
  sslength=strlen(ss);
  s=fs;
  
  while(count>0)
  {
   if(!strncmp(s,ss,sslength))
   {
    if(argc==3)
    {
     putchar('"');
     putstr(ss);
     putchar('"');
    }
    else
    {
     putstr(sr);
    }
    s+=sslength;
    count-=sslength;
   }
   else
   {
    putchar(*s);
    s++;
    count--;
   }
  }
 
 }

 free(fs);

 return 0;
}

