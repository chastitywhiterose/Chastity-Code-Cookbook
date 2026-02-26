/* chastelib_format.h */

/*
 This extension library for chastelib breaks the tradition of the core functions and is designed to
 reduce code size by passing multiple arguments to format integers.
 The idea is having the convenience of printf except coding it from the ground up in my own style.
*/ 

/*
 This function is a copy of intstr except that the radix and width of the integer
 are passed as local arguments rather than being set globally
 I made this for the specific case of programs that display multiple bases or
 lengths of strings which must be lined up just like the original test suite I made.
*/

char *intfmt(unsigned int i,int radix,int int_width)
{
 int width=0;
 char *s=int_string+usl;
 *s=0;
 while(i!=0 || width<int_width)
 {
  s--;
  *s=i%radix;
  i/=radix;
  if(*s<10){*s+='0';}
  else{*s=*s+'A'-10;}
  width++;
 }
 return s;
}

/*
 This genius function prints exactly 3 strings! You may wonder what use this might be.
 Usually someone doesn't just print an integer but they have information printed before or after it on the same line.
 A function that prints 3 strings means that the host program can call just this function to
 print strings of any kind that exist in the program, including conversions made with intstr or intfmt
*/

void putfmt(const char *a,const char *b,const char *c)
{
 putstring(a);
 putstring(b);
 putstring(c);
}
