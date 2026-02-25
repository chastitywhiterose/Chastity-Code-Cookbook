/* chastlib_input.h */

const int input_string_length=256; /*the length that I expect will be enough for*/
char main_string[usl+1]; /*global string which will be used to store string of integers. Size is usl+1 for terminating zero*/

/*variable to store how many characters were read into the string last time*/
int read_count=0;

/*
 This function prints a string using fwrite.
 This algorithm is the best C representation of how my Assembly programs also work.
 Its true purpose is to be used in the putint function for conveniently printing integers, 
 but it can print any valid string.
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

