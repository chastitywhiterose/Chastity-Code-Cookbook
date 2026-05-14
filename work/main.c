#include <unistd.h>
#include <fcntl.h>
#include "chastelib-unistd.h"

int fd; /*file descriptor used in unistd*/
char bytes[17]; /*the byte buffer for hex and text dumping*/
int count=1; /*keeps track of how many bytes were read during each row*/

/*outputs the ASCII text to the right of the hex field*/
void textdump()
{
 int a,x=0;

 x=count;
 while(x<0x10)
 {
  putstr("   ");
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

 putstr(bytes);
}

/*outputs up to 16 bytes on each row in hexadecimal*/

void hexdump()
{
 int x,address=0;
 x=0;
 while((count=read(fd,bytes,16)))
 {
  int_width=8;
  putint(address);
  putstr(" ");

  int_width=2;
  x=0;
  while(x<count)
  {
   putint(bytes[x]&0xFF);
   putstr(" ");
   x++;
  }
  textdump();
  putstr("\n");

  address+=count;
 }
 putstr("EOF\n");
}

int main(int argc, char *argv[])
{
 int argx,x,c;
   
 radix=0x10; /*set radix for integer output*/
 int_width=1; /*set default integer width*/

 if(argc==1)
 {
  putstr
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
  /*
   open the file for reading or writing because
   chastehex is unique in that it can do both
  */
  fd=open(argv[1],O_RDWR);
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

 if(argc==2)
 {
  hexdump(); /*hex dump only if filename given*/
 }

 if(argc>2)
 {
  x=strint(argv[2]); /*extract a number from the argument string after the filename*/
  lseek(fd,x,SEEK_SET); /*seek to the address given in argument*/
 }

 /*read a byte at address of second arg*/
 if(argc==3)
 {

  count=read(fd,&c,1);
  int_width=8;
  putstr(intstr(x));
  putstr(" ");
  /*
   according to the read function manual page "man 2 read",
   a return of 0 means the end of file and
   a return of -1 means some kind of error
   therefore, anything less than 1 means we should stop reading
   and assume End Of File by printing EOF
  */
  if(count<1){putstr("EOF");}
  else
  {
   int_width=2;
   putstr(intstr(c));
  }
  putstr("\n");
 }

 /*any arguments past the address are hex bytes to be written*/
 if(argc>3)
 {
  argx=3;
  while(argx<argc)
  {
   c=strint(argv[argx]);
   int_width=8;
   putstr(intstr(x));
   putstr(" ");
   int_width=2;
   putstr(intstr(c));
   putstr("\n");
   write(fd,&c,1);
   x++;
   argx++;
  }
 }
 
 close(fd);
 _exit(0); 
}

/* gcc -Wall -ansi -pedantic main.c -o chastehex */

