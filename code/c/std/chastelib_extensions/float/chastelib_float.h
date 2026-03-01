/*
 This file is a library of functions written by Chastity White Rose. The functions are for converting strings into integers and integers into strings.
 I did it partly for future programming plans and also because it helped me learn a lot in the process about how pointers work
 as well as which features the standard library provides, and which things I need to write my own functions for.

 As it turns out, the integer output routines for C are too limited for my tastes. This library corrects this problem.
 Using the global variables and functions in this file, integers can be output in bases/radixes 2 to 36
*/

/*
 These two lines define a static array with a size big enough to store the digits of an integer, including padding it with extra zeroes.
 The integer conversion function always references a pointer to this global string, and this allows other standard library functions
 such as printf to display the integers to standard output or even possibly to files.
*/

#define fsl 0x100 /*fsl stands for Float String Length*/
char float_string[fsl+1]; /*global string which will be used to store string of integers. Size is usl+1 for terminating zero*/

 /*radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal*/
/*int radix=2;*/
/*default minimum digits for printing integers*/
/*int int_width=1;*/

/*
This function is one that I wrote because the standard library can display integers as decimal, octal, or hexadecimal, but not any other bases(including binary, which is my favorite).
My function corrects this, and in my opinion, such a function should have been part of the standard library, but I'm not complaining because now I have my own, which I can use forever!
More importantly, it can be adapted for any programming language in the world if I learn the basics of that language.
*/

char *fltstr(float f)
{
 /*set the pointer to the approximate middle of the array*/
 char *s=float_string+fsl/2;
 char *sf=s; /*make a copy of this pointer for later use*/

 int width=0; /*width of integer part of the float*/
 int i=f; /*get integer portion of the float by implicit cast*/

 f-=i; /*subtract this integer portion from the original float*/

 /*
  first convert the integer portion of the float into a string
  using the exact same algorithm as the intstr function
 */
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

*sf='.'; /*replace that zero from earlier with our "point"*/

 /*while the float part is not zero, we multiply by the base and extract the digits one at a time*/
 while(f!=0)
 {
  sf++; /*going to the right of the point*/
  f*=radix; /*multiply the float by radix*/
  i=f; /*cast the float to an int again*/
  f-=i; /*subtract this int from the float again*/
  *sf=i%radix;
  if(*sf<10){*sf+='0';}
  else{*sf=*sf+'A'-10;}
 }


*sf=0; /*terminate the end of the float part string with a zero */

 
 return s;
}


