#include <unistd.h>
#include <fcntl.h>
#include "chastelib-unistd.h"
 
int main(int argc, char *argv[])
{
 int argx,x;
 int fd[3]; /*file descriptors used in unistd*/
 int c0=1,c1=0,c2=0;

 radix=0x10; /*set radix for integer output*/
 int_width=1; /*set default integer width*/
   
 if(argc<3)
 {
  putstr("Welcome to Chastity's Hex Compare program also known as \"chastecmp\".\n\n");
  putstr("Enter two filenames as command line arguments such as:\n");
  putstr(argv[0]);
  putstr(" file1.txt file2.txt\n");
  return 0;
 }

 argx=1;
 while(argx<3)
 {
  /*
   open the file for reading only
   chastecmp only reads and compares bytes
  */
  fd[argx]=open(argv[argx],O_RDONLY);
  if(fd[argx]==-1)
  {
   putstr(argv[argx]);
   putstr("\nFailed to open file\n");
   _exit(1); 
  }
  else
  {
   putstr(argv[argx]);
   putstr(" open\n");
  }
  
  argx++;
 }

  x=0;
 while(c0)
 {
  int e1,e2; /*used to detech when end is found*/

  e1=read(fd[1],&c1,1);
  e2=read(fd[2],&c2,1);

  if(e1<1){putstr(argv[1]);putstr(" EOF\n");c0=0;}
  if(e2<1){putstr(argv[2]);putstr(" EOF\n");c0=0;}
 
  if(c0 && c1!=c2)
  {
   int_width=8;
   putint(x);
   putstr(" ");
   int_width=2;
   putint(c1);
   putstr(" ");
   putint(c2);
   putstr("\n");
  }
  x++;  
 }
 
 argx=1;
 while(argx<3)
 {
  close(fd[argx]);
  argx++;
 }

 return 0;
}
