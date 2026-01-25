/*
 this file is dedicated to using ANSI escape codes in Assembly programs.
;Using special strings of text, it is possible to reposition the cursor in Linux terminal programs
;Below are some links where I learned about ANSI escape sequences;

https://notes.burke.libbey.me/ansi-escape-codes/
https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
*/

char ansi_gray[]="\x1B[1;30m";
char ansi_red[]="\x1B[1;31m";
char ansi_green[]="\x1B[1;32m";
char ansi_yellow[]="\x1B[1;33m";
char ansi_blue[]="\x1B[1;34m";
char ansi_magenta[]="\x1B[1;35m";
char ansi_cyan[]="\x1B[1;36m";
char ansi_white[]="\x1B[1;37m";

char ansi_clear[]="\x1B[2J";

char ansi_home[]="\x1B[H";

int temp_radix;
int temp_width;

void save_radix()
{
 temp_radix=radix;
 temp_width=int_width;
}

void load_radix()
{
 radix=temp_radix;
 int_width=temp_width;
}


char ansi_string[0x100]; /*global string which will be used to build the move escape sequence*/

/*a function to set the text to any color I want!*/

void text_rgb(int r,int g,int b)
{
 save_radix();

 bufcat("\x1B[38;2;");
 
 radix=10;
 int_width=1;
 
 bufcat(intstr(r));
 bufchar(';');
 
 bufcat(intstr(g));
 bufchar(';');

 bufcat(intstr(b));
 bufchar('m');
 bufchar(0);

 bufput(); /*send entire buffer to terminal*/
 load_radix();
}

/*a function to move the cursor wherever I want with escape sequences*/

void move_xy(int x,int y)
{
 save_radix();
 
 bufcat("\x1B[");
 
 radix=10;
 int_width=1;
 
 bufcat(intstr(y+1));
 bufchar(';');
 
 bufcat(intstr(x+1));
 bufchar('H');
 
 bufput(); 
 load_radix();
}
