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
 
 fclose(fp);

 return 0;
}

