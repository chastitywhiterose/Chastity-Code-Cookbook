/*
This file is a library of functions written by Chastity White Rose. The functions are for converting strings into integers and integers into strings. I did it partly for future programming plans and also because it helped me learn a lot in the process about how pointers work as well as which features the standard library provides and which things I need to write my own functions for.
*/

/* These two lines define a static array with a size big enough to store the digits of an integer including padding it with extra zeroes. The function which follows always returns a pointer to this global string and this allows other standard library functions such as printf to display the integers to standard output or even possibly to files.*/

#define usl 256
char us[usl+1]; /*global string which will be used to store string of integers*/

/*
This function is one that I wrote because the standard library can display integers as decimai, octai, or hexadecimal but not any other bases(including binary which is my favorite). My function corrects this and in my opinion such a function should have been part of the standard library but I'm not complaining because now I have my own which I can use forever!
*/

char* intstr(unsigned int i,int base,int width)
{
 char *s=us+usl;
 *s=0;
 do
 {
  s--;
  *s=i%base;
  i/=base;
  if(*s<10){*s+='0';}else{*s=*s+'A'-10;}
  width--;
 }
 while(i!=0 || width>0);
 return s;
}

/*
This function is my own replacement for the strtol function from the C standard library. I didn't technically need to make this function because the functions from stdlib.h can already convert strings from bases 2 to 36 into integers. However my function is simpler because it only requires 2 arguments instead of three and it also does not handle negative numbers. Never have I needed negative integers but if I ever do I can use the standard functions or write my own in the future.
*/

int strint(char *s,int base)
{
 int i=0;
 char c;
 if( base<2 || base>36 ){printf("Error: base %i is out of range!\n",base);return i;}
 while( *s == ' ' || *s == '\n' || *s == '\t' ){s++;} /*skip whitespace at beginning*/
 while(*s!=0)
 {
  c=*s;
  if( c >= '0' && c <= '9' ){c-='0';}
  else if( c >= 'A' && c <= 'Z' ){c-='A';c+=10;}
  else if( c >= 'a' && c <= 'z' ){c-='a';c+=10;}
  else if( c == ' ' || c == '\n' || c == '\t' ){return i;}
  else{printf("Error: %c is not an alphanumeric character!\n",c);return i;}
  if(c>=base){printf("Error: %c is not a valid character for base %i\n",*s,base);return i;}
  i*=base;
  i+=c;
  s++;
 }
 return i;
}




void intstr_test(unsigned int i)
{
 int width=0;
 /*width=sizeof(i)*8;*/
 printf("bin: %s\n",intstr(i,2,width));
 printf("oct: %s\n",intstr(i,8,width));
 printf("dec: %s\n",intstr(i,10,width));
 printf("hex: %s\n",intstr(i,16,width));
 printf("\n");
 printf("%%o: %o\n",i);
 printf("%%d: %d\n",i);
 printf("%%X: %X\n",i);
 printf("\n");
}


void strint_test(char *s,int base)
{
 int i=strint(s,base);
 printf("string=%s\n",s);
 printf("base=%d\n\n",base);
 intstr_test(i);
}


void debug()
{
 strint_test("1987",10);
}
