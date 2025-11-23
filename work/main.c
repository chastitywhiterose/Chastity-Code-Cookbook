#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

FILE* fp; /*file pointer*/
char bytes[17]; /*the byte buffer for hex and text dumping*/
int count=1; /*keeps track of how many bytes were read during each row*/

/*outputs the ASCII text to the right of the hex field*/
void textdump()
{
 int a,x=0;

 x=count;
 while(x<0x10)
 {
  putstring("   ");
  x++;
 }

 x=0;
 while(x<count)
 {
  a=bytes[x];
  if( a < 0x20 || a > 0x7E ){a='.';bytes[x]=a;}
  x++;
 }
 bytes[x]=0;

 putstring(bytes);
}

/*outputs up to 16 bytes on each row in hexadecimal*/
void hexdump()
{
 int x,address=0;
 x=0;
 while((count=fread(bytes,1,16,fp)))
 {
  int_width=8;
  putint(address);
  putstring(" ");

  int_width=2;
  x=0;
  while(x<count)
  {
   putint(bytes[x]);
   printf(" ");
   x++;
  }
  textdump();
  putstring("\n");

  address+=count;
 }
}

int main(int argc, char *argv[])
{
 int argx,x,c;
   
 radix=0x10; /*set radix for integer output*/
 int_width=1; /*set default integer width*/

 if(argc==1)
 {
  putstring
  (
   "Welcome to chastehex! The tool for reading and writing bytes of a file!\n\n"
   "To hexdump an entire file:\n\n\tchastehex file\n\n"
   "To read a single byte at an address:\n\n\tchastehex file address\n\n"
   "To write a single byte at an address:\n\n\tchastehex file address value\n\n"
  );
  return 0;
 }

 if(argc>1)
 {
  fp=fopen(argv[1],"rb+");
  if(fp==NULL)
  {
   printf("File \"%s\" cannot be opened.\n",argv[1]);
   return 1;
  }
  else
  {
   putstring(argv[1]);
   putstring("\n");
  }
 }

 if(argc==2)
 {
  hexdump(); /*hex dump only if filename given*/
 }

 if(argc>2)
 {
  x=strint(argv[2]);
  fseek(fp,x,SEEK_SET);
 }



 /*read a byte at address of second arg*/
 if(argc==3)
 {
  c=fgetc(fp);
  int_width=8;
  putstring(intstr(x));
  putstring(" ");
  if(c==EOF){putstring("EOF");}
  else
  {
   int_width=2;
   putstring(intstr(c));
  }
  putstring("\n");
 }

 /*any arguments past the address are hex bytes to be written*/
 if(argc>3)
 {
  argx=3;
  while(argx<argc)
  {
   c=strint(argv[argx]);
   int_width=8;
   putstring(intstr(x));
   putstring(" ");
   int_width=2;
   putstring(intstr(c));
   putstring("\n");
   fputc(c,fp);
   x++;
   argx++;
  }
 }
 
 fclose(fp);
 return 0;
}

/* gcc -Wall -ansi -pedantic main.c -o chastehex */
