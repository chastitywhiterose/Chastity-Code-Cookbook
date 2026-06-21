/*
This source file contains exactly two functions. The first is a function that can take any regular integer and convert it into a string representing the binary form of it.
*/

#define ulength 100  /*the size of the array to be defined next*/
char u[ulength]; /*universal array for my integer to binary string function*/

char* int_to_binary_string(unsigned int i,int width)
{
 char *s=u+ulength;
 *s=0;
 do
 {
  s--;
  *s=i&1;
  i>>=1;
  *s+='0';
  width--;
 }
 while(i!=0 || width>0);
 return s;
}

/*
Converts any binary string of '0' and '1' characters into the integer equivalent. 
*/

int binary_string_to_int(char *s)
{
 int i=0;
 char c;
 while( *s == ' ' || *s == '\n' || *s == '\t' ){s++;} /*skip whitespace at beginning*/
 while(*s!=0)
 {
  c=*s;
  if( c == '0' || c == '1' ){c-='0';}
  else if( c == ' ' || c == '\n' || c == '\t' ){return i;}
  else{printf("Error: %c is not a valid character for base 2.\n",c);return i;}
  i<<=1;
  i+=c;
  s++;
 }
 return i;
}
