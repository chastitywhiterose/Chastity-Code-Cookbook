#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastebuf.h"
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

int key=0,key1,key2;

void input_operate()
{
 int width=16,height=16;
 int x=byte_selected_x;
 int y=byte_selected_y;
 int c; /*character used for some operations*/

 /*these secondary keys are used for control characters such as arrow keys*/
 key1=0;
 key2=0;

 /*
  when a special key such as an arrow key is pressed, it actually sends an escape sequence which is really hard to debug by conventional means
  We have to use getchar immediately to get these characters and branch according to what they are
  so that we can process them and they won't be mistaken as other characters
 */ 
 if(key==0x1B)
 {
  key1=getchar();
  key2=getchar();
  
  /*
  RAM[0x80]=key;
  RAM[0x81]=key1;
  RAM[0x82]=key2;
  */
 }
 
 if(key2=='A'){y--;if(y<0){y=15;}}
 if(key2=='B'){y++;if(y>=height){y=0;}}
 if(key2=='C'){x++;if(x>=width){x=0;}}
 if(key2=='D'){x--;if(x<0){x=15;}}

 if(key=='+'){RAM[x+y*width]++;}
 if(key=='-'){RAM[x+y*width]--;}
 
 /*handle hexadecimal number input*/
 if( key >= '0' && key <= '9' ){c=key-'0';   RAM[x+y*width]<<=4;RAM[x+y*width]|=c;}
 if( key >= 'a' && key <= 'f' ){c=key-'a'+10;RAM[x+y*width]<<=4;RAM[x+y*width]|=c;}
  
 byte_selected_x=x;
 byte_selected_y=y;
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

FILE* fp; /*file pointer*/
int count=0; /*keeps track of how many bytes were last read from file*/

int main(int argc, char *argv[])
{

 if(argc==1)
 {
  putstring
  (
   "Welcome to Hexplore! The tool for exploring a file in hexadecimal!\n\n"
   "Enter a filename as an argument to this program to read from it.\n"
   "You will then see an interface where you can modify the bytes of the file\n"
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
 
 /*
 if we reach this point, the file was opened and we turn off line buffering
 we will then attempt to read from the file
 */

 stty_cbreak(); /*disable line buffering for this program*/
 
 /*attempt to read 256 bytes for the first page*/
 count=fread(RAM,1,0x100,fp);

 while(/*key!=0x1B&&*/key!='q')
 {
  text_rgb(0xFF,0xFF,0xFF);
 
  putstring(ansi_clear);
  putstring(ansi_home);
 
  
  /*
   display hexadecimal byte value of key pressed
   some keys evaluate to the same number
  */
  move_xy(0,0);
  radix=16;
  int_width=2;
  putint(key);
  putstring(" ");
  putint(key1);
  putstring(" ");
  putint(key2);
  
  /*display a character based representation of key pressed*/
  move_xy(9,0);
  putchar(key);

  
  move_xy(16,0);
  putstring("Hexplore : Chastity White Rose");  ;

  move_xy(0,19);
  putstring("Arrows : Select Byte");
  move_xy(0,20);
  putstring("0 to f : Enter Hexadecimal");
 

 
  /*display x and y of selection*/
  move_xy(57,0);
  putstring("X=");
  putint(byte_selected_x);
  putstring(" Y=");
  putint(byte_selected_y);
   
  move_xy(RAM_view_x,RAM_view_y);

  RAM_hexdump();
 
  move_xy(0,0);
  key=getchar();  /*fread(&key,1,1,stdin);*/
  input_operate();
 }
 
 fclose(fp);
 
 return 0;
}

