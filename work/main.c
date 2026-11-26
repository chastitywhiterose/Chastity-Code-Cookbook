#include <stdio.h>

int main(int argc, char *argv[])
{
 char s[]="Hello World\n"; /*an array of characters*/
 int count=0;              /*used to count how many bytes will be written*/
 char *p=s;          /*pointer used to find terminating zero of string*/
 while(*p){p++;}           /*loop until zero found and immediately exit*/
 count=p-s;                /*count is the difference of pointers p and s*/
 fwrite(s,1,count,stdout); /*https://cppreference.com/w/c/io/fwrite.html*/
 return 0;
}

