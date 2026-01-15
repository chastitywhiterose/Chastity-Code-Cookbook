#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-ansi.h"

char RAM[0x1000];
int RAM_address=0;
int RAM_view_x=16;
int RAM_view_y=4;

/*outputs the ASCII text to the right of the hex field*/
void RAM_textdump(int y,int width)
{
 int a,x=0;
 int count=16;
 x=count;
 while(x<0x10)
 {
  putstring("   ");
  x++;
 }

 x=0;
 while(x<count)
 {
  a=RAM[RAM_address+x+y*width];
  if( a < 0x20 || a > 0x7E ){a='.';}
  putchar(a);
  x++;
 }
/* RAM[RAM_address+y*width]=0;*/

 /*putstring(bytes);*/
}

void RAM_hexdump()
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
  RAM_textdump(y,width);
  
  putstring("\n");
  y++;
  move_xy(RAM_view_x,RAM_view_y+y); radix=16;
 }

}

int key=0;

int main(int argc, char *argv[])
{


 putstring(ansi_green);

 while(key!=0x1B&&key!='q')
 {
 
  putstring(ansi_clear);
  putstring(ansi_home);
 
  putchar(key);
  putstring(" ");
  move_xy(10,0);
  putint(key);
   
  move_xy(RAM_view_x,RAM_view_y);

  RAM_hexdump();
 
  move_xy(0,0);
  key=getchar();
  
 }
 
 return 0;
}
