#include <unistd.h>
#include <fcntl.h>
#include "chastelib-unistd.h"
#include <string.h>
 
int main(int argc, char *argv[])
{
 int fd; /*file descriptor used in unistd*/
 char temp[0x100]; /*buffer used to temporarily store data read from a file*/
 char *s; /*pointer to temporary buffer*/
 char *ss,*sr; /*string search and replacement pointers*/
 int sslength;
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

  /*
   open the file for reading only
  */
  fd=open(argv[1],O_RDONLY);
  if(fd==-1)
  {
   putstr("Failed to open file\n");
   _exit(1); 
  }
  else
  {
   putstr(argv[1]);
   putstr("\n");
  }
  
 }
 
 /*
  if only the filename was given but nothing else, we will just display all characters to stdout
 */
 
 if(argc==2)
 {
  while(read(fd,temp,1))
  {
   write(1,temp,1);
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
  s=temp;
  
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
   count=read(fd,s,1);  /*read one byte*/
   if(count==0){break;} /*if we couldn't read this byte, end the program*/
   
   if(s[0]!=ss[0]) /*if this byte is not the same as the first in search string*/
   {
    write(1,s,1);  /*write this byte to stdout and move on*/
   }
  
   /*
    the first character matched read more bytes see if the entire search string is a match
   */
   else
   {
   
    count=read(fd,s,sslength-1); /*read enough bytes to have an equal length string as search string*/
    s[count+1]=0; /*terminate this temporary string with a zero*/
    
    if(count<(sslength-1)) /*if we don't have enough characters left in the file to compare*/
    {
     putstr(s); /*write the buffer of characters read before we end*/
     break;     /*break out of the loop, which ends the program*/
    }

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
      char q='"'; /*temp variable that contains a quote character*/
      write(1,&q,1);
      putstr(ss);
      write(1,&q,1);
     }
     /*but if there is a replacement string, we print it instead of the search string*/
     else
     {
      putstr(sr);
     }
    }
    
    /*
     but if the strings were not equal print the characters
     in the buffer as they were in the original file
    */
    else
    {
     putstr(s);
    }
    
   }
 
  } /*end of while loop*/
 
 } /*end of if(argc>2) section*/
  
 close(fd);
 _exit(0); 

}

