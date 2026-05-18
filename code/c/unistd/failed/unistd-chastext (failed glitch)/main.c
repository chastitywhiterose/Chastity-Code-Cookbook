#include <unistd.h>
#include <fcntl.h>
#include "chastelib-unistd.h"
/*#include <string.h>*/

/*
 rather than including string.h, I am keeping with the them of excluding the C standard library for an extra challenge
 Therefore, this unistd version of chastext includes my own versions of strlen and strcmp.
*/


/*
 Chastity's implementation of strlen
 This is the same routine normally used in putstring from chastelib
*/

long unsigned int strlen(const char *s)
{
 int count=0;              /*used to calcular how many bytes this string is*/
 const char *p=s;          /*pointer used to find terminating zero of string*/
 while(*p){p++;}           /*loop until zero found and immediately exit*/
 count=p-s;                /*count is the difference of pointers p and s*/
 return count;             /*return how many bytes were written*/
}

/*
This is a very basic way of making the strcmp function
As long as the character indexed in the first string is not zero
and both characters are equal to each other, it will continue the loop
If the loop ends, then we have either reached a difference of bytes or
they are both zero, in which case, the difference returned is zero.
If this function zero, then you know the strings are the same.
*/

int strcmp(const char *s0,const char *s1)
{
 while(*s0 && *s0==*s1)
 {
  s0++;
  s1++;
 }
 return *s0-*s1;
}
 
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
   
    count=read(fd,s+1,sslength-1); /*read enough bytes to have an equal length string as search string*/
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

