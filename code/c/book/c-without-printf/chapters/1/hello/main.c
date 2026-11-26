/*include the standard input output library*/
#include <stdio.h>
/*the main function where all C programs begin*/
int main(int argc, char *argv[])
{
 /*an array of characters*/
 char s[]="Hello World\n";
 /*used to count how many bytes will be written*/
 int count=0;
 /*pointer used to find terminating zero of string*/
 const char *p=s;
 /*loop until zero found and immediately exit*/
 while(*p){p++;}
 /*count is the difference of pointers p and s*/
 count=p-s;
 /*https://cppreference.com/w/c/io/fwrite.html*/
 fwrite(s,1,count,stdout);
 /*return to operating system with exit code 0*/
 return 0;
}
