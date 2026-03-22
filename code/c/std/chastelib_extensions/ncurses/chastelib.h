/*
 This file is a C library of functions written by Chastity White Rose. The functions are for converting strings into integers and integers into strings.
 I did it partly for future programming plans and also because it helped me learn a lot in the process about how pointers work
 as well as which features the standard library provides, and which things I need to write my own functions for.

 As it turns out, the integer output routines for C are too limited for my tastes. This library corrects this problem.
 Using the global variables and functions in this file, integers can be output in bases/radixes 2 to 36.
 
 Although this code is commented, I have also written a readme.md file designed to explain the usage of these functions and the philosophy behind them.
*/

/*
 These two lines define a static array with a size big enough to store the digits of an integer, including padding it with extra zeroes.
 The integer conversion function always references a pointer to this global string, and this allows other standard library functions
 such as printf to display the integers to standard output or even possibly to files.
*/

#define usl 32 /*usl stands for Unsigned String Length*/
char int_string[usl+1]; /*global string which will be used to store string of integers. Size is usl+1 for terminating zero*/

/*radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal*/
int radix=2;
/*default minimum digits for printing integers*/
int int_width=1;

/*
The intstr function is one that I wrote because the standard library can display integers as decimal, octal, or hexadecimal, but not any other bases(including binary, which is my favorite).
My function corrects this, and in my opinion, such a function should have been part of the standard library, but I'm not complaining because now I have my own, which I can use forever!
More importantly, it can be adapted for any programming language in the world if I learn the basics of that language.
*/

char *intstr(unsigned int i)
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
The strint_errors variable is used to keep track of how many errors happened in the strint function.
The following errors can occur:

Radix is not in range 2 to 36
Character is not a number 0 to 9 or alphabet A to Z (in either case)
Character is alphanumeric but is not valid for current radix

If any of these errors happen, error messages are printed to let the programmer or user know what went wrong in the string that was passed to the function.
If getting input from the keyboard, the strint_errors variable can be used in a conditional statement to tell them to try again and recall the code that grabs user input.
*/

int strint_errors = 0; 

/*
 The strint function is my own replacement for the strtol function from the C standard library.
 I didn't technically need to make this function because the functions from stdlib.h can already convert strings from bases 2 to 36 into integers.
 However, my function is simpler because it only requires 2 arguments instead of three, and it also does not handle negative numbers.
I have never needed negative integers, but if I ever do, I can use the standard functions or write my own in the future.
*/

int strint(const char *s)
{
 int i=0;
 char c;
 strint_errors = 0; /*set zero errors before we parse the string*/
 if( radix<2 || radix>36 ){ strint_errors++; printf("Error: radix %i is out of range!\n",radix);}
 while( *s == ' ' || *s == '\n' || *s == '\t' ){s++;} /*skip whitespace at beginning*/
 while(*s!=0)
 {
  c=*s;
  if( c >= '0' && c <= '9' ){c-='0';}
  else if( c >= 'A' && c <= 'Z' ){c-='A';c+=10;}
  else if( c >= 'a' && c <= 'z' ){c-='a';c+=10;}
  else if( c == ' ' || c == '\n' || c == '\t' ){break;}
  else{ strint_errors++; printf("Error: %c is not an alphanumeric character!\n",c);break;}
  if(c>=radix){ strint_errors++; printf("Error: %c is not a valid character for radix %i\n",*s,radix);break;}
  i*=radix;
  i+=c;
  s++;
 }
 return i;
}

/*
 This function prints a string using fwrite.
 This algorithm is the best C representation of how my Assembly programs also work.
 Its true purpose is to be used in the putint function for conveniently printing integers, 
 but it can print any valid string.
*/

int putstring(const char *s)
{
 int count=0;              /*used to calcular how many bytes will be written*/
 const char *p=s;          /*pointer used to find terminating zero of string*/
 while(*++p){}             /*loop until zero found and immediately exit*/
 count=p-s;                /*count is the difference of pointers p and s*/
 fwrite(s,1,count,stdout); /*https://cppreference.com/w/c/io/fwrite.html*/
 return count;             /*return how many bytes were written*/
}

/*
 A function pointer named putstr which is a shorter name for calling putstring
 But this doesn't exist just to save bytes of source files. Otherwise I wouldn't have these huge comments!
 This exists so that all strings can be redirected to another function for output.
 For example, if the strings were written to a log file during a game which didn't use a terminal.
*/
int (*putstr)(const char *)=putstring;

/*
 This function uses both intstr and putstring to print an integer in the currently selected radix and width.
*/

void putint(unsigned int i)
{
 putstr(intstr(i));
}

/*
 Those four functions above are the core of chastelib.
 While there may be extensions written for specific programs, these functions are essential for absolutely every program I write.
 
 The only reason you would not need them is if you only output numbers in decimal or hexadecimal, because printf in C can do all that just fine.
 However, the reason my core functions are superior to printf is that printf and its family of functions require the user to memorize all the arcane symbols for format specifiers.
 
 The core functions are primarily concerned with standard output and the conversion of strings and integers. They do not deal with input from the keyboard or files. A separate extension will be written for my programs that need these features.
*/

