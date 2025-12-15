/*
This file is a library of functions written by Chastity White Rose. The functions are for converting strings into integers and integers into strings. I did it partly for future programming plans and also because it helped me learn a lot in the process about how pointers work as well as which features the standard library provides and which things I need to write my own functions for.
*/

/* These two lines define a static array with a size big enough to store the digits of an integer including padding it with extra zeroes. The function which follows always returns a pointer to this global string and this allows other standard library functions such as printf to display the integers to standard output or even possibly to files.*/

#define usl 256
char us[usl+1]; /*global string which will be used to store string of integers*/

 /*radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal*/
int radix=2;
/*default minimum digits for printing integers*/
int int_width=1;

/*
This function is one that I wrote because the standard library can display integers as decimai, octai, or hexadecimal but not any other bases(including binary which is my favorite). My function corrects this and in my opinion such a function should have been part of the standard library but I'm not complaining because now I have my own which I can use forever!
*/

char* intstr(unsigned int i)
{
 int width=0;
 char *s=us+usl;
 *s=0;
 do
 {
  s--;
  *s=i%radix;
  i/=radix;
  if(*s<10){*s+='0';}else{*s=*s+'A'-10;}
  width++;
 }
 while(i!=0 || width<int_width);
 return s;
}

/*
This function is my own replacement for the strtol function from the C standard library. I didn't technically need to make this function because the functions from stdlib.h can already convert strings from bases 2 to 36 into integers. However my function is simpler because it only requires 2 arguments instead of three and it also does not handle negative numbers. Never have I needed negative integers but if I ever do I can use the standard functions or write my own in the future.
*/

int strint(char *s)
{
 int i=0;
 char c;
 if( radix<2 || radix>36 ){printf("Error: radix %i is out of range!\n",radix);return i;}
 while( *s == ' ' || *s == '\n' || *s == '\t' ){s++;} /*skip whitespace at beginning*/
 while(*s!=0)
 {
  c=*s;
  if( c >= '0' && c <= '9' ){c-='0';}
  else if( c >= 'A' && c <= 'Z' ){c-='A';c+=10;}
  else if( c >= 'a' && c <= 'z' ){c-='a';c+=10;}
  else if( c == ' ' || c == '\n' || c == '\t' ){return i;}
  else{printf("Error: %c is not an alphanumeric character!\n",c);return i;}
  if(c>=radix){printf("Error: %c is not a valid character for radix %i\n",*s,radix);return i;}
  i*=radix;
  i+=c;
  s++;
 }
 return i;
}

/*
this function prints a string using fwrite
This is the best C representation of how my Assembly programs also work/
*/

void putstring(char *s)
{
 int c=0;
 char *p=s;
 while(*p++){c++;} 
 fwrite(s,1,c,stdout);
}

void putint(unsigned int i)
{
 putstring(intstr(i));
}

