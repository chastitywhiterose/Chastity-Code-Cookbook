#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

char RAM[0x1000];
int RAM_address=0;

void print_RAM()
{
 int x,y;
 int width=16,height=16;
 
 RAM[0x66]=0x40;
 
 radix=16;
 
 y=0;
 while(y<height)
 {
 
  int_width=8;
  putint(RAM_address+y*width);
  putstring(" ");
 
  int_width=2;
  x=0;
  while(x<width)
  {
   putint(RAM[x+y*width]);
   putstring(" ");
   x++;
  }
  putstring("\n");
  y++;
 }

}

int main(int argc, char *argv[])
{

 print_RAM();
  
 return 0;
}
