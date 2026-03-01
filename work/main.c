#include <ncurses.h>
#include "chastelib_ncurses.h"

int main()
{
 int key=0; /*default key to 0 which in the context of my program means nothing has been pressed yet.*/
 int a=0,b,c; /*variables for this test program*/

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
 b=strint("10");
 c=strint("100");
 

 while(key!='q')
 {
  putstring("Official test suite for the C version of chastelib.\n");
  putstring("This edition uses ncurses\n");
 
  if(key!=0)
  {
   printw("char: %c code: %X\n\n", key,key);
  }

  if(key==KEY_DOWN){b++;}

 
 if(key == KEY_F(1)) /* Check for F1 key. Usually this would display a help message. */
 {
  printw("F1 Key pressed");
 }

 
 a=b-0x10;
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
   putchar(a);
  }

  putstring("\n");
  a+=1;
 }

  refresh();			/* Print it on to the real screen */
  key = getch();		/* Wait for user input */
  clear();	

 }
 
 endwin();			/* End curses mode
 		  */
 printf("Program terminated normally with %c key.\n",key);
 
 return 0;
}

/* gcc -Wall -ansi -pedantic main.c -o main -lncurses && ./main */
/* https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/init.html */

