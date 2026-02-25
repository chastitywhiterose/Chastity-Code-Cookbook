/* chastlib_input.h */

#define input_string_length 256; /*the length that I expect will be enough for*/
char main_string[usl+1]; /*global string which will be used to store string of integers. Size is usl+1 for terminating zero*/

/*variable to store how many characters were read into the string last time*/
int read_count=0;

/*
this is my basic function for recieving input from the keyboard
it uses a global variable to store the string into
However, it returns a pointer to this string which makes it really convenient if I need
to read something and then immediately print it or copy it to another variable

It reads characters into the string and stops at the first whitespace character.
This can be a regular space, tab, or newline.
My reasoning for this is because I plan for multiple strings to exist on one line.
This is similar to how a command and its arguments are entered on the command line.
By stopping every time a separating whitespace character is found, the tokens can be processed manually.
*/

char *getstring()
{
 char *s=main_string,*p=s,c=0;
 while( c!=' ' && c!='\n' && c!='\t' )
 {
  fread(p,1,1,stdin); /*read exactly 1 byte*/
  c=*p; /*character equals the last character read*/
  p++; /*increment the pointer to the next byte*/
 }
 *--p=0; /*go back to last character (space,newline,tab) and replace with zero*/
 read_count=s-p;
 return s;
}

/*More functions are planned, but so far I am off to a great start with this function!*/
