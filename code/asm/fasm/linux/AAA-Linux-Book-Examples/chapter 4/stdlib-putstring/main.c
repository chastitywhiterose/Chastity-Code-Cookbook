#include <stdio.h>

int putstring(const char *s)
{
 int count=0;              /*used to count how many bytes will be written*/
 const char *p=s;          /*pointer used to find terminating zero of string*/
 while(*p){p++;}           /*loop until zero found and immediately exit*/
 count=p-s;                /*count is the difference of pointers p and s*/
 fwrite(s,1,count,stdout); /*https://cppreference.com/w/c/io/fwrite.html*/
 return count;             /*return how many bytes were written*/
}

int main(int argc, char *argv[])
{
 putstring("The putstring function can print any string!\n");
 return 0;
}

