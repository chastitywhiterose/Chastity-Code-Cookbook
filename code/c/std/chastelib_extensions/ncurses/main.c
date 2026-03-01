#include <ncurses.h>
#include "chastelib_ncurses.h"

int main()
{
 int key=0; /*default key to 0 which in the context of my program means nothing has been pressed yet.*/
 int a=0,b,c,d; /*variables for this test program*/

 /*set the default radix and width for integers at the beginning of the program*/ 
 radix=16;
 int_width=1;

 initscr();			/* Start curses mode 		*/
 raw();				/* Line buffering disabled	*/
 keypad(stdscr, TRUE);		/* We get F1, F2 etc..		*/
 noecho();			/* Don't echo() while we do getch */

 /*
  I use strint to set the variables by strings rather than immediate values directly
  Doing it this way looks silly, but it is for the purpose of testing the strint function
 */
 b=strint("10"); /*will always be radix*/
 c=b; /*save what the radix was at the beginning. This will be used later.*/
 d=strint("100"); /*will always be radix squared*/
 
 while(key!='q')
 {
  putstring("Official test suite for the C version of chastelib.\n");
  putstring("This edition uses ncurses\n");
 
  if(key!=0)
  {
   printw("char: %c code: %X\n\n", key,key);
  }
  else{putstring("\n\n");}

  if(key==KEY_UP){if(b>c){b--;}}
  if(key==KEY_DOWN){if(b<d){b++;}}
  if(key==KEY_LEFT){if(b>=c+c){b-=c;}}
  if(key==KEY_RIGHT){if(b<=d-c){b+=c;}}
 
  if(key == KEY_F(1)) /* Check for F1 key. Usually this would display a help message. */
  {
   clear();	/*clear the screen before showing help*/
   printw("F1 Key pressed: Showing help screen\n\n");

   putstring("This program is an ncurses program which also interacts with chastelib.\n\n");
   putstring("chastelib is library for converting between integers and strings in multiple radices\n\n");
   putstring("ncurses is library for controlling keyboard input and printing text at specific locations in a terminal.\n\n");
   
   putstring("This program allows you to view the binary, hexadecimal, and decimal numbers of 8-bit value\n");
   putstring("The arrow keys let you scroll through the list. The q key exits the program\n");

   refresh();			/* Print it on to the real screen */
 
   key = getch();		/* Wait for user input */
   clear();	/*clear the screen before ending help*/
   continue; /*continue to the next phase of the main loop*/
  }

 /*the actual loop that shows the data for 16 numbers at a time*/
 a=b-c;
 while(a<b)
 {
  radix=2;
  int_width=8;
  putint(a);
  putstring(" ");
  radix=16;
  int_width=2;
  putint(a);
  putstring(" ");
  radix=10;
  int_width=3;
  putint(a);

  if(a>=0x20 && a<=0x7E)
  {
   putstring(" ");
   addch(a);
  }

  putstring("\n");
  a+=1;
 }

  refresh();			/* Print it on to the real screen */
  key = getch();		/* Wait for user input */
  clear();	

 }
 
 endwin();			/* End curses mode */
 printf("Program terminated normally with %c key.\n",key);
 
 return 0;
}

/* gcc -Wall -ansi -pedantic main.c -o main -lncurses && ./main */

