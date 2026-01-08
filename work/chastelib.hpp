/*
 This file is a library of functions written by Chastity White Rose. The functions are for converting strings into integers and integers into strings.
 I did it partly for future programming plans and also because it helped me learn a lot in the process about how pointers work
 as well as which features the standard library provides and which things I need to write my own functions for.

 As it turns out, the integer output routines for C are too limited for my tastes. This library corrects this problem.
 Using the global variables and functions in this file, integers can be output in bases/radixes 2 to 36
*/

/*
 These two lines define a static array with a size big enough to store the digits of an integer including padding it with extra zeroes.
 The function which follows always returns a pointer to this global string and this allows other standard library functions
 such as printf to display the integers to standard output or even possibly to files.
*/

#define usl 32 /*usl stands for Unsigned String Length*/
char int_string[usl+1]; /*global string which will be used to store string of integers. Size is usl+1 for terminating zero*/

 /*radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal*/
int radix=2;
/*default minimum digits for printing integers*/
int int_width=1;

/*
This function is one that I wrote because the standard library can display integers as decimai, octai, or hexadecimal but not any other bases(including binary which is my favorite).
My function corrects this and in my opinion such a function should have been part of the standard library but I'm not complaining because now I have my own which I can use forever!
*/

char* intstr(unsigned int i)
{
 int width=0;
 char *s=int_string+usl;
 *s=0;
 while(i!=0 || width<int_width)
 {
  s--;
  *s=i%radix;
  i/=radix;
  if(*s<10){*s+='0';}else{*s=*s+'A'-10;}
  width++;
 }

 return s;
}

/*
 This function prints a string using cout instead of fwrite.
 This is the best C++ representation of how my Assembly programs also work/
 It's true purpose is to be used in the putint function for conveniently printing integers, 
 but it can print any valid string.

 In the original C version, the putstring function was implemented with some pointer math to
 get the length of the string and then fwrite was used:
    fwrite(s,1,c,stdout);

 Technically this entire function could have been summed up in one statement:
    cout<<s;

 But where is the fun in that? I already had the logic for determining the length of the string.
 I also think that the new way of using << to write to cout is confusing because it is the left shift operator from C.
 Therefore, I wrote the function the following way to rebel against this common practice.
*/

void putstring(const char *s)
{
 int c=0;
 const char *p=s;
 while(*p++){c++;} 
 cout.write(s,c);
}

/*
 This function uses both intstr and putstring to print an integer in the currently selected radix and width
*/
void putint(unsigned int i)
{
 putstring(intstr(i));
}

/*
 This function is my own replacement for the strtol function from the C standard library.
 I didn't technically need to make this function because the functions from stdlib.h can already convert strings from bases 2 to 36 into integers.
 However my function is simpler because it only requires 2 arguments instead of three and it also does not handle negative numbers.
 Never have I needed negative integers but if I ever do I can use the standard functions or write my own in the future.
*/

int strint(const char *s)
{
 int i=0;
 char c;
 if( radix<2 || radix>36 ){ cout << "Error: radix " << i << " is out of range!\n"; return i;}
 while( *s == ' ' || *s == '\n' || *s == '\t' ){s++;} /*skip whitespace at beginning*/
 while(*s!=0)
 {
  c=*s;
  if( c >= '0' && c <= '9' ){c-='0';}
  else if( c >= 'A' && c <= 'Z' ){c-='A';c+=10;}
  else if( c >= 'a' && c <= 'z' ){c-='a';c+=10;}
  else if( c == ' ' || c == '\n' || c == '\t' ){return i;}
  else{ cout << "Error: " << c << " is not an alphanumeric character!\n";return i;}
  if(c>=radix){ cout << "Error: " << c << " is not a valid character for radix " << radix; return i;}
  i*=radix;
  i+=c;
  s++;
 }
 return i;
}

/*
 Those four functions above are pretty much the entirety of chastelib.
 While there may be extensions written for specific programs, these functions are essential for absolutely every program.
 The only reason you would not need them is if you only output numbers in decimal or hexadecimal, because printf in C can do all that just fine.
*/
