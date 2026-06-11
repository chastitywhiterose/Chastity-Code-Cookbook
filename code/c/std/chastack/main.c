#include <stdio.h>
#include "chastelib.h"

#define stack_length 0x10
int stack[stack_length]; /*stack array of size stack_length*/

/*
variables named after registers

esp is declared as a pointer because its only purpose in Assembly is managing the stack
ebp is declared as a pointer to keep track of the original stack pointer address

all other registers are used as normal integers
*/
int eax,ebx,ecx,edx,esi,edi,*ebp,*esp;

void push(i)
{
 esp--;
 *esp=i;
}

int pop()
{
 int i=*esp;
 *esp=0; /*set the value at [esp] to 0 to delete it*/
 esp++;
 return i;
}


int main(int argc, char **argv)
{

 /*set the radix used for integer display*/
 radix=10;
 int_width=1;

 /*set the stack pointer to where it should start*/
  esp=stack+stack_length;
  ebp=esp; /*backup address of esp to ebp*/

 push(1);  
 push(2);  
 push(4);  
 push(8);  

 push(360); /*push a wrong number to the stack*/
 pop();     /*pop it off the stack to show it is deleted*/

 push(16);  
 push(32);  
 push(64);  
 push(128);  
 
 putstr("printing the stack\n");
 debug_putstack();
 putstr("end of debug stack\n");
 
 
 while(esp<ebp)
 {
  putint(*esp);
  putstr("\n");
  esp++;
 }
 
 return 0;
}








/* print all command line arguments on a separate line */


/*
 int x=1;
 while(x!=argc)
 {
  putstr(argv[x]);
  putstr("\n");
  x++;
 }
*/

