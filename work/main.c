#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-ansi.h"

char RAM[0x1000];
int RAM_address=0;
int RAM_view_x=0;
int RAM_view_y=2;

int byte_selected_x=0;
int byte_selected_y=0;


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
 radix=16;
 
 y=0;
 while(y<height)
 {
  text_rgb(0x00,0xFF,0xFF);
  int_width=8;
  radix=16;
  putint(RAM_address+y*width);
  putstring(" ");
  text_rgb(0xFF,0x00,0xFF);
  int_width=2;
  x=0;
  while(x<width)
  {
  
   if(x==byte_selected_x&&y==byte_selected_y)
   {
    text_rgb(0x00,0xFF,0x00); /*change color before next byte is printed*/
    putint(RAM[x+y*width]&0xFF); /*print this byte in the new color*/
    text_rgb(0xFF,0x00,0xFF); /*change it back*/
   }
   else
   {
    putint(RAM[x+y*width]&0xFF);
   }
 
   putstring(" ");


   x++;
  }
  text_rgb(0xFF,0xFF,0x00);
  RAM_textdump(y,width);
  
  putstring("\n");
  y++;
  move_xy(RAM_view_x,RAM_view_y+y); radix=16;
 }

}

int key=0;

void input_operate()
{
 int width=16,height=16;
 
 if(key=='A'){byte_selected_y--;if(byte_selected_y<0){byte_selected_y=15;}}
 if(key=='B'){byte_selected_y++;if(byte_selected_y>=15){byte_selected_y=0;}}
 if(key=='C'){byte_selected_x++;if(byte_selected_x>15){byte_selected_x=0;}}
 if(key=='D'){byte_selected_x--;if(byte_selected_x<0){byte_selected_x=15;}}

 if(key=='+'){RAM[byte_selected_x+byte_selected_y*width]++;}
 if(key=='-'){RAM[byte_selected_x+byte_selected_y*width]--;}
 
 

}

/*
 This function is only one command, but it is extemely important so I made it a separate function.
 With this, every character pressed on the keyboard will pass the control back to the program
 instead of waiting for a new line. This is essential for text editors and games where arrow keys move
 the cursor or player. But remember, this only works in Linux but not Windows.
*/
void stty_cbreak()
{
 system("stty cbreak");
}


int main(int argc, char *argv[])
{

 stty_cbreak(); /*disable line buffering for this program*/

 while(/*key!=0x1B&&*/key!='q')
 {
 
  text_rgb(0xFF,0xFF,0xFF);
 
  putstring(ansi_clear);
  putstring(ansi_home);
 
  putchar(key);
  putstring(" ");
  move_xy(10,0);
 
  radix=16;
  putint(key);
   
  move_xy(RAM_view_x,RAM_view_y);

  RAM_hexdump();
 
  move_xy(0,0);
  key=getchar();  /*fread(&key,1,1,stdin);*/
  input_operate();
  
 }
 
 return 0;
}
