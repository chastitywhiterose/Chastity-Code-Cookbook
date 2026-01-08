#include <iostream>
#include <fstream>
using namespace std;
#include "chastelib.hpp"

std::fstream f;
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
 f.read(bytes,16);
 count=f.gcount();
 while(count)
 {
  int_width=8;
  putint(address);
  putstring(" ");

  int_width=2;
  x=0;
  while(x<count)
  {
   putint(bytes[x]&0xFF);
   putstring(" ");
   x++;
  }
  textdump();
  putstring("\n");

  address+=count;
  f.read(bytes,16);
  count=f.gcount();
 }
}

int main(int argc, char *argv[])
{
 int argx,x;
   
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
  f.open(argv[1],ios::in|ios::out|ios::binary);
  if(!f.is_open())
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
  f.seekp(x);
 }



 /*read a byte at address of second arg*/
 if(argc==3)
 {
  f.read(&bytes[0],1);
  count=f.gcount();
  int_width=8;
  putint(x);
  putstring(" ");
  if(count==0){putstring("EOF");}
  else
  {
   int_width=2;
   putint(bytes[0]&0xFF);
  }
  putstring("\n");
 }

 /*any arguments past the address are hex bytes to be written*/
 if(argc>3)
 {
  argx=3;
  while(argx<argc)
  {
   bytes[0]=strint(argv[argx]);
   int_width=8;
   putint(x);
   putstring(" ");
   int_width=2;
   putint(bytes[0]&0xFF);
   putstring("\n");
   f.write(bytes,1);
   x++;
   argx++;
  }
 }
 
 f.close();
 return 0;
}

