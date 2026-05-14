#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chastelib.h"
 
int main(int argc, char *argv[])
{
 FILE *fp; /*file pointer*/
 char temp[0x100]; /*buffer used to temporarily store data read from a file*/
 char *s; /*pointer used to search through the file array*/
 char *ss,*sr; /*string search and replacement pointers*/
 int sslength;
 int count;
   
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
 
 /*
  if only the filename was given but nothing else, we will just display all characters to stdout
 */
 
 if(argc==2)
 {
  while(fread(temp,1,1,fp))
  {
   fwrite(temp,1,1,stdout);
  }
  return 0; /*return with no errors*/
 }
 
 
 
 
 
  /*
 if only a search string is given, display the whole file except also quote parts that match the search string
 this is a good way to prove that the program is correctly finding them
 
 but if a replacement string was provided, then this section will replace the search string with the replacement
 */
 
 if(argc>2)
 {
  s=temp;
  
  /*assign pointer to the search string and find its length*/
  ss=argv[2];
  sslength=strlen(ss);
  
   /*if 4 or more arguments are present, use the 4th arg as the replacement string*/
  if(argc>3)
  {
   sr=argv[3];
  }

  /*next begin this loop which cleverly reads and modified data*/  
  while(count>0)
  {
   count=fread(s,1,1,fp); /*read one byte*/
   if(s[0]==ss[0]) /*is this byte the same as the first in search string?*/
   {
    count=fread(s+1,1,sslength-1,fp); /*read enough bytes to have an equal length string as search string*/
    s[sslength]=0; /*terminate this temporary string with a zero*/

    /*if the temporary string equals the search string, we do these operations*/
    if(!strcmp(s,ss))
    {
     if(argc==3)
     {
      putchar('"');
      putstr(ss);
      putchar('"');
     }
     else if(argc>3)
     {
      putstr(sr);
     }
    }
    
   }
   else
   {
    fwrite(temp,1,1,stdout); /*write this byte to stdout and move on*/
   }
  
  }
 
 }
 
 
 
 
 
 
 fclose(fp);

 return 0;
}

