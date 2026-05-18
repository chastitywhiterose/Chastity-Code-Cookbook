#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chastelib.h"
 
int main(int argc, char *argv[])
{
 FILE *fp; /*file pointer*/
 char s[0x100]; /*buffer used to temporarily store data read from a file*/
 char *ss,*sr; /*string search and replacement pointers*/
 int sslength;
 int file_address=0;
 int count=1;
   
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
  while(fread(s,1,1,fp))
  {
   fwrite(s,1,1,stdout);
  }
  return 0; /*return with no errors*/
 }
 
 /*
 if only a search string is given, display the whole file except also quote parts that match the search string
 this is a good way to prove that the program is correctly finding them
 
 but if a replacement string was provided, then this section will replace the search string with the replacement string
 
 This version of the program does not load the entire file into memory and therefore avoids seeking backwards.
 It reads the minimal amount of information needed to check for string matches.
 */
 
 if(argc>2)
 {
  /*assign pointer to the search string and find its length*/
  ss=argv[2];
  sslength=strlen(ss);
  
  /*if 4 or more arguments are present, use the 4th arg as the replacement string*/
  if(argc>3)
  {
   sr=argv[3];
  }

  /*
   next begin this loop which cleverly reads and modified data
   It attempts to read one byte.
   If this byte matches the first in the search string, it does a separate 
  */
  while(count>0)
  {
   fseek(fp,file_address,SEEK_SET); /*seek to file_address (which starts at 0)*/
   count=fread(s,1,sslength,fp); /*read number of bytes equal to search string length*/
   
   s[count]=0; /*terminate our temporary string with zero*/
   
   if(count<sslength){break;} /*if we couldn't read enough bytes, end this loop*/
   
   /*if the temporary string equals the search string, we do these operations*/
   if(!strcmp(s,ss))
   {
    /*
     if there was not a replacement string argument,
     put quotes around the matching strings
     so that the user can see where they are
    */
    if(argc==3)
    {
     putchar('"');
     putstr(ss);
     putchar('"');
    }
    /*but if there is a replacement string, we print it instead of the search string*/
    else
    {
     putstr(sr);
    }
    file_address+=count;
   }
   /*
    but if the strings were not equal print the characters
    in the buffer as they were in the original file
    print the first character and then go to next address
   */
   else
   {
    fwrite(s,1,1,stdout);
    file_address++;
   }
  
  } /*end of while loop*/
  
  /*
   the loop above breaks when we don't have enough characters to match with a search string
   In this case, we simply write to standard output the last characters that were read
   so we can display the rest of the file
  */
  fwrite(s,1,count,stdout);
 
 } /*end of if(argc>2) section*/
  
 fclose(fp);

 return 0;
}

