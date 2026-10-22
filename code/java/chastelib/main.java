/*
 Java Port of Chastity's library of standard functions
*/
public class main
{

 public static void main(String[] args)
 {
  int a=0,b=0x100;
  putstr("Official test suite for the Java version of chastelib.\n");


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

 }

 static void putstr(String s)
 {
  System.out.print(s);
 }

/*radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal*/
static int radix=2;
/*default minimum digits for printing integers*/
static int int_width=1;

static String intstr(int i)     /*Chastity's supreme integer to string conversion function*/
{
 int width=0;                   /*the width or how many digits including prefixed zeros are printed*/
 int b=0;                       /*byte for the current character*/
 String s="";
 while(i!=0 || width<int_width) /*loop to fill the string with every required digit plus prefixed zeros*/
 {
  b=i%radix;                    /*get the remainder of division by the radix or base*/
  i/=radix;                     /*divide the input by radix*/
  if(b<10){b+='0';}             /*convert digits 0 to 9 to the ASCII character for that digit*/
  else{b=b+'A'-10;}             /*for digits higher than 9, convert to letters starting at A*/
  s=(char)b+s;                  /*prefix return string with this digit's character*/
  width++;                      /*increment the width so we know when enough digits are saved*/
 }
 return s;                      /*return this string to be used by putstr,printf,std::cout or whatever*/
}


static void putint(int i)
{
 putstr(intstr(i));
}

static void putchar(int i)
{
 String s=""; /*create empty string*/
 s=(char)i+s; /*add char of i to string*/
 putstr(s);   /*print the string*/
}


}
