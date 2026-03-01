#include <ncurses.h>

int main()
{	
 initscr();			/* Start curses mode 		  */
 printw("Hello World !!!");	/* Print Hello World		  */
 refresh();			/* Print it on to the real screen */
 getch();			/* Wait for user input */
 endwin();			/* End curses mode		  */

 return 0;
}

/* gcc -Wall -ansi -pedantic main.c -o main -lncurses && ./main */
/* https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/helloworld.html */

