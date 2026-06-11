#include <stdio.h>
#include <string.h>
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
 int x=1;

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
 
 /*
 Now the fun begins. Each argument is processed as a number or command
 */

 while(x!=argc)
 {
  putstr(argv[x]);
  putstr("\n");
  
  /*first, we check for commands before we check for integers*/
  
  if(!strcmp(argv[x],"add"))
  {
   printf("The add command adds the top two numbers on the stack.\n");
   eax=pop();
   ebx=pop();
   eax+=ebx;
   push(eax);
  }

  else /*try to get a number and push it to the stack*/
  {
   
  eax=strint(argv[x]); /*get a number from the string*/
  if(strint_errors)
  {
   putstr("Last argument was not a number, but it could be a command!\n");
  }
  
  putstring("number returned by strint(argv[x]) is: ");
  putint(eax);
  putstr("\n");

  push(eax);
  }
  
  x++;
 }
 
 while(esp<ebp)
 {
  putint(*esp);
  putstr("\n");
  esp++;
 }
 
 return 0;
}








/* print all command line arguments on a separate line */




