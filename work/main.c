#include <ncurses.h>
#include "chastelib_ncurses.h"

FILE* fp; /*file pointer*/
int file_address=0;
int count=0; /*keeps track of how many bytes were last read from file*/
int eof_char='?'; /*character used by this program to show user the end of file is reached*/

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
  addch(a);
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
  int_width=8;
  radix=16;
  putint(RAM_address+file_address+y*width);
  putstring(" ");
  int_width=2;
  x=0;
  while(x<width)
  {
  
   if(x==byte_selected_x&&y==byte_selected_y)
   {
    putint(RAM[x+y*width]&0xFF); /*print this byte in the new color*/
   }
   else
   {
    putint(RAM[x+y*width]&0xFF);
   }
 
   putstring(" ");


   x++;
  }
  RAM_textdump(y,width);
  
  putstring("\n");
  y++;
  move(RAM_view_y+y,RAM_view_x); radix=16; /*ncurses yx order corrected*/
 }

}

int key=0;

void input_operate()
{
 int width=16,height=16;
 int x=byte_selected_x;
 int y=byte_selected_y;
 int c; /*character used for some operations*/

 if(key2=='A'){y--;if(y<0){y=15;}}
 if(key2=='B'){y++;if(y>=height){y=0;}}
 if(key2=='C'){x++;if(x>=width){x=0;}}
 if(key2=='D'){x--;if(x<0){x=15;}}

 if(key2==0x35)
 {
  if(file_address!=0)
  {
   /*before changing page, save the modified bytes from this page back to the file*/
   fseek(fp,file_address,SEEK_SET);
   fwrite(RAM,1,count,fp);
   /*change page and read from the correct file position*/
   file_address-=0x100;
   fseek(fp,file_address,SEEK_SET);
   count=fread(RAM,1,0x100,fp);
   c=count;while(c<0x100){RAM[c]=eof_char;c++;}
  }
 }

 
 if(key2==0x36)
 {
  /*before changing page, save the modified bytes from this page back to the file*/
  fseek(fp,file_address,SEEK_SET);
  fwrite(RAM,1,count,fp);
  /*change page and read from the correct file position*/
  file_address+=0x100;
  fseek(fp,file_address,SEEK_SET);
  count=fread(RAM,1,0x100,fp);
  c=count;while(c<0x100){RAM[c]=eof_char;c++;}
 }

 if(key=='+'){RAM[x+y*width]++;}
 if(key=='-'){RAM[x+y*width]--;}
 
 /*handle hexadecimal number input*/
 if( key >= '0' && key <= '9' ){c=key-'0';   RAM[x+y*width]<<=4;RAM[x+y*width]|=c;}
 if( key >= 'a' && key <= 'f' ){c=key-'a'+10;RAM[x+y*width]<<=4;RAM[x+y*width]|=c;}
  
 byte_selected_x=x;
 byte_selected_y=y;
}


int main(int argc, char *argv[])
{
 int c; /*used to index the RAM sometimes*/

 if(argc==1)
 {
  printf
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
 step 0 complete: file opened before this code executes

 step 1 is initializing ncurses to manage input for the rest of the program
 we will then attempt to read from the file and launch the main loop
 */

 /*set the default radix and width for integers at the beginning of the program*/ 
 radix=16;
 int_width=1;

 initscr();			/* Start curses mode 		*/
 raw();				/* Line buffering disabled	*/
 keypad(stdscr, TRUE);		/* We get F1, F2 etc..		*/
 noecho();			/* Don't echo() while we do getch */

  /*attempt to read 256 bytes for the first page*/
 count=fread(RAM,1,0x100,fp);
 c=count;while(c<0x100){RAM[c]=eof_char;c++;}



 while(key!='q')
 {
  /*
   display hexadecimal byte value of key pressed
   some keys evaluate to the same number
  */
  move(0,0);
  radix=16;
  int_width=2;
  putint(key);
  putstring(" ");
  putint(key1);
  putstring(" ");
  putint(key2);
  
  /*display a character based representation of key pressed*/
  move(0,9); /*ncurses yx order corrected*/
  putchar(key);

  
  move(0,16); /*ncurses yx order corrected*/
  putstring("Hexplore : Chastity White Rose");  ;

  move(19,0); /*ncurses yx order corrected*/
  putstring("Arrows: Select Byte");
  move(20,0); /*ncurses yx order corrected*/
  putstring("0 to f: Enter Hexadecimal");
  move(19,60); /*ncurses yx order corrected*/
  putstring("q: quit");
  move(20,27); /*ncurses yx order corrected*/
  putstring("page up/down: navigate file");

  /*display x and y of selection*/
  move(0,57); /*ncurses yx order corrected*/
  putstring("X=");
  putint(byte_selected_x);
  putstring(" Y=");
  putint(byte_selected_y);
   
  move(RAM_view_y,RAM_view_x); /*ncurses yx order corrected*/

  RAM_hexdump();
 
  move(0,0);
  
  refresh();			/* Print it on to the real screen */
  key = getch();		/* Wait for user input */
  input_operate();

  clear();	

 }
 
 /*
  before closing the file and ending the program, we must write the modified bytes to the file
  However, we only write (count) bytes to the file so that we don't accidentally add the full
  256 bytes of the current hex page if they were not in the original file
 */
 fseek(fp,file_address,SEEK_SET); /*seek back to the file address for this page*/
 fwrite(RAM,1,count,fp); /*write count bytes back into the original location they were read from*/
 
 fclose(fp);

 endwin();			/* End curses mode */
 printf("Program terminated normally with %c key.\n",key);
 
 return 0;
}

