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
More importantly, it can be adapted for any programming language in the world if I learn the basics of that language. That being said, C is the best language and I will use it forever.
*/

char *intstr(unsigned int i)    /*Chastity's supreme integer to string conversion function*/
{
 int width=0;                   /*the width or how many digits including prefixed zeros are printed*/
 char *s=int_string+usl;        /*a pointer starting to the place where we will end the string with zero*/
 *s=0;                          /*set the zero that terminates the string in the C language*/
 while(i!=0 || width<int_width) /*loop to fill the string with every required digit plus prefixed zeros*/
 {
  s--;                          /*decrement the pointer to go left for corrent digit placing*/
  *s=i%radix;                   /*get the remainder of division by the radix or base*/
  i/=radix;                     /*divide the input by radix*/
  if(*s<10){*s+='0';}           /*fconvert digits 0 to 9 to the ASCII character for that digit*/
  else{*s=*s+'A'-10;}           /*for digits higher than 9, convert to letters starting at A*/
  width++;                      /*increment the width so we know when enough digits are saved*/
 }
 return s;                      /*return this string to be used by putstr,printf,std::cout or whatever*/
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
 This function is my own replacement for the strtol function from the C standard library.
 I didn't technically need to make this function because the functions from stdlib.h can already convert strings from bases 2 to 36 into integers.
 However, my function is simpler because it only requires 2 arguments instead of three, and it also does not handle negative numbers.
I have never needed negative integers, but if I ever do, I can use the standard functions or write my own in the future.
*/

int strint(const char *s)
{
 int i=0;
 char c;
 strint_errors = 0; /*set zero errors before we parse the string*/
 if( radix<2 || radix>36 ){ strint_errors++; cout << "Error: radix " << i << " is out of range!\n";}
 while( *s == ' ' || *s == '\n' || *s == '\t' ){s++;} /*skip whitespace at beginning*/
 while(*s!=0)
 {
  c=*s;
  if( c >= '0' && c <= '9' ){c-='0';}
  else if( c >= 'A' && c <= 'Z' ){c-='A';c+=10;}
  else if( c >= 'a' && c <= 'z' ){c-='a';c+=10;}
  else if( c == ' ' || c == '\n' || c == '\t' ){break;}
  else{ strint_errors++; cout << "Error: " << c << " is not an alphanumeric character!\n";break;}
  if(c>=radix){ strint_errors++; cout << "Error: " << *s << " is not a valid character for radix " << radix << "\n"; break;}
  i*=radix;
  i+=c;
  s++;
 }
 return i;
}


/*
 This function prints a string using cout instead of fwrite.
 This is the best C++ representation of how my Assembly programs also work/
 It's true purpose is to be used in the putint function for conveniently printing integers, 
 but it can print any valid string.

 In the original C version, the putstring function was implemented with some pointer math to
 get the length of the string and then fwrite was used:
	fwrite(s,1,count,stdout);

 Technically this entire function could have been summed up in one statement:
    cout<<s;

 But where is the fun in that? I already had the logic for determining the length of the string.
 I also think that the new way of using << to write to cout is confusing because it is the left shift operator from C.
 Therefore, I wrote the function the following way to rebel against this common practice.
*/

int putstring(const char *s)
{
 int count=0;              /*used to calcular how many bytes will be written*/
 const char *p=s;          /*pointer used to find terminating zero of string*/
 while(*p){p++;}           /*loop until zero found and immediately exit*/
 count=p-s;                /*count is the difference of pointers p and s*/
 cout.write(s,count);      /*https://en.cppreference.com/w/cpp/io/basic_ostream/write.html*/
 return count;             /*return how many bytes were written*/
}

/*
 This function uses both intstr and putstring to print an integer in the currently selected radix and width.
*/
void putint(unsigned int i)
{
 putstring(intstr(i));
}

/*
 Those four functions above are the core of chastelib.
 While there may be extensions written for specific programs, these functions are essential for absolutely every program I write.
 
 The only reason you would not need them is if you only output numbers in decimal or hexadecimal, because printf in C can do all that just fine.
 However, the reason my core functions are superior to printf is that printf and its family of functions require the user to memorize all the arcane symbols for format specifiers.
 
 The core functions are primarily concerned with standard output and the conversion of strings and integers. They do not deal with input from the keyboard or files. A separate extension will be written for my programs that need these features.
*/

