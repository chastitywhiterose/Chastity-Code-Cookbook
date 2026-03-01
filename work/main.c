#include <ncurses.h>
#include "chastelib_ncurses.h"

int main()
{
 int key=0;
 initscr();			/* Start curses mode 		*/
 raw();				/* Line buffering disabled	*/
 keypad(stdscr, TRUE);		/* We get F1, F2 etc..		*/
 noecho();			/* Don't echo() while we do getch */
 
 putstring("Official test suite for the C version of chastelib.\n");
 putstring("This edition uses ncurses\n");

 while(key!='q')
 {
 
 if(key == KEY_F(1))		/* Check for F1 key. Usually this would display a help message. */
 printw("F1 Key pressed");
 else
 {
  if(key!=0)
  {
   printw("char: %c code: %X\n", key,key);
  }
 }

  refresh();			/* Print it on to the real screen */
  key = getch();		/* Wait for user input */
 }
 
 endwin();			/* End curses mode		  */
 return 0;
}

/* gcc -Wall -ansi -pedantic main.c -o main -lncurses && ./main */
/* https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/init.html */

