/*
 chastebuf.h
 
 This file contains some global variables and two utility functions.
 The idea is that you have data stored in a very large array to be printed. However, rather than calling putstring multiple times, you can call the bufcat
 function to store the strings into the buffer but not print them yet. Then, when it is time to print everything so far, you call bufput and everything is printed at once.
*/

char buffer[0x10000]; /*buffer of characters to store things we are not printing yet*/
char *bp=buffer;    /*bp stands for buffer pointer*/
 
void bufcat(char *s)
{
 while(*s)
 {
  *bp++=*s++;
 }
 *bp=0;
}

/*
this clever function uses the difference between the current pointer and the original buffer array to know how many bytes to write
this is fast because no loop or other function is needed to know the length of the string
*/
void bufput()
{
 fwrite(buffer,1,bp-buffer,stdout);
 bp=buffer;
 *bp=0;
}

/*
sometimes, I need to append a specific character rather than a string to the buffer. That is why this function is sometimes useful.
*/
void bufchar(char c)
{
 *bp++=c;
}

