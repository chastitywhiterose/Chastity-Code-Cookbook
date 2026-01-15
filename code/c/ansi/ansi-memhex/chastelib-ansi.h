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

char ansi_move[0x100]; /*global string which will be used to build the move escape sequence*/

void mov_xy(int x,int y)
{
 char *si,*di;
 
 di=ansi_move;
 
 /* *di++=0x1B;*/
 *di++='[';
 
 radix=10;
 int_width=1;
 
 si=intstr(y);
 
 while(*si!=0)
 {
  *di++=*si++;
 }
 
 
 
}
