/*
 Java Port of Chastity's library of standard functions

 This Java class is a library of functions written by Chastity White Rose.
 The functions are for converting strings into integers and integers into strings.

 Core Four Functions

 intstr: Convert an integer to a string in bases 2 to 36
 strint: Convert a string in bases 2 to 36 to an integer
 putstr: Print a string to standard output
 putint: Print an integer using intstr and then putstr

*/
public class main
{

 public static void main(String[] args)
 {
  String s="Official test suite for the Java version of chastelib.\n";
  int a=0,b=0x10;

  radix=16;
  int_width=1;

  putstr(s);

  b=strint("100"); /*convert string to an integer*/
  if(strint_errors!=0) /*if there are errors, print some messages and exit the program*/
  {
   putstr("Input string passed to strint function contains errors.\n");
   putstr("Fix the invalid characters or radix and try again.\n");
   return;
  }

  while(a<b)
  {
   radix=2;
   int_width=8;
   putint(a);
   putstr(" ");
   radix=16;
   int_width=2;
   putint(a);
   putstr(" ");
   radix=10;
   int_width=3;
   putint(a);

   if(a>=0x20 && a<=0x7E)
   {
    putstr(" ");
    putchar(a);
   }

   putstr("\n");
   a++;
  }

  putstr(s);
 }

 static void putstr(String s)
 {
  System.out.print(s);
 }

 static void putchar(int i)
 {
  String s=""; /*create empty string*/
  s=(char)i+s; /*add char of i to string*/
  putstr(s);   /*print the string*/
 }

 /*radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal*/
 static int radix=2;
 /*default minimum digits for printing integers*/
 static int int_width=1;

 static String intstr(int i)     /*Chastity's supreme integer to string conversion function*/
 {
  int width=0;                   /*the width or how many digits including prefixed zeros are printed*/
  int c=0;                       /*byte for the current character*/
  String s="";
  while(i!=0 || width<int_width) /*loop to fill the string with every required digit plus prefixed zeros*/
  {
   c=i%radix;                    /*get the remainder of division by the radix or base*/
   i/=radix;                     /*divide the input by radix*/
   if(c<10){c+='0';}             /*convert digits 0 to 9 to the ASCII character for that digit*/
   else{c=c+'A'-10;}             /*for digits higher than 9, convert to letters starting at A*/
   s=(char)c+s;                  /*prefix return string with this digit's character*/
   width++;                      /*increment the width so we know when enough digits are saved*/
  }
 return s;                      /*return this string to be used by putstr,printf,std::cout or whatever*/
}


 static void putint(int i)
 {
  putstr(intstr(i));
 }

 static int strint_errors = 0; 


 static int strint(String s)
 {
  int i=0;
  int c;
  strint_errors = 0; /*set zero errors before we parse the string*/
  if( radix<2 || radix>36 ){ strint_errors++; putstr("Error: radix is out of range!\n");}
  int x=0;
  while(x<s.length())
  {
   c=s.charAt(x);
   if( c >= '0' && c <= '9' ){c-='0';}
   else if( c >= 'A' && c <= 'Z' ){c-='A';c+=10;}
   else if( c >= 'a' && c <= 'z' ){c-='a';c+=10;}
   else if( c == ' ' || c == '\n' || c == '\t' ){break;}
   else
   {
    strint_errors++;
    putstr("Error: character is not alphanumeric -> ");
    putchar(s.charAt(x));
    putstr("\n");
    break;
   }
   if(c>=radix)
   {
    strint_errors++;
    putstr("Error: character is not a valid for current radix -> ");
    putchar(s.charAt(x));
    putstr("\n");
    break;
   }
   i*=radix;
   i+=c;
   x++;
  }
  return i;
 }

}
