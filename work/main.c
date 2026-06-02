#include <unistd.h>

int putstring(const char *s)
{
 int count=0;      /*used to count how many bytes will be written*/
 const char *p=s;  /*pointer used to find terminating zero of string*/
 while(*p){p++;}   /*loop until zero found and immediately exit*/
 count=p-s;        /*count is the difference of pointers p and s*/
 write(1,s,count); /*the unix system call way of writing the bytes*/
 return count;     /*return how many bytes were written*/
}

#define usl 0x100 /*usl stands for Unsigned or Universal String Length.*/
char int_string[usl+1]; /*global string which will be used to store string of integers. Size is usl+1 for terminating zero*/

/*radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal*/
int radix=2;
/*default minimum digits for printing integers*/
int int_width=1;

char *intstr(unsigned int i)    /*Chastity's supreme integer to string conversion function*/
{
 int width=0;                   /*the width or how many digits including prefixed zeros are printed*/
 char *s=int_string+usl;        /*a pointer starting to the place where we will end the string with zero*/
 *s=0;                          /*set the zero that terminates the string in the C language*/
 while(i!=0 || width<int_width) /*loop to fill the string with every required digit plus prefixed zeros*/
 {
  s--;                          /*decrement the pointer to go left for correct digit placing*/
  *s=i%radix;                   /*get the remainder of division by the radix or base*/
  i/=radix;                     /*divide the input by radix*/
  if(*s<10){*s+='0';}           /*fconvert digits 0 to 9 to the ASCII character for that digit*/
  else{*s=*s+'A'-10;}           /*for digits higher than 9, convert to letters starting at A*/
  width++;                      /*increment the width so we know when enough digits are saved*/
 }
 return s;                      /*return this string to be used by putstr,printf,std::cout or whatever*/
}

void putint(unsigned int i)
{
 putstring(intstr(i));
}

int main(int argc, char *argv[])
{
 int a=0;

 putstring("The putstring function can print any string!\n");
 putstring("The intstr function can convert an integer to a string!\n");
 putstring("The putint function calls intstr and putstring to print an integer\n");
 
 while(a<0x10)
 {
  putint(a);
  putstring("\n");
  a++;
 }
 
 _exit(0);
}

