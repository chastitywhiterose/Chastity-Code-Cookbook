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

 /*
 Now the fun begins. Each argument is processed as a number or command
 */

 while(x!=argc)
 {
  /*
  putstr(argv[x]);
  putstr("\n");
  */
  
  /*first, we check for commands before we check for integers*/
  
  if(!strcmp(argv[x],"add"))
  {
   /*putstr("The add command adds using the top two numbers on the stack.\n");*/
   ebx=pop();
   eax=pop();
   eax+=ebx;
   push(eax);
  }
  
  else if(!strcmp(argv[x],"mul"))
  {
   /*putstr("The mul command multiplies using the top two numbers on the stack.\n");*/
   ebx=pop();
   eax=pop();
   eax*=ebx;
   push(eax);
  }

  else if(!strcmp(argv[x],"sub"))
  {
   /*putstr("The sub command subtracts using the top two numbers on the stack.\n");*/
   ebx=pop();
   eax=pop();
   eax-=ebx;
   push(eax);
  }

  else if(!strcmp(argv[x],"div"))
  {
   /*putstr("The div command divides using the top two numbers on the stack.\n");*/
   ebx=pop();
   eax=pop();
   eax/=ebx;
   push(eax);
  }

  else /*try to get a number and push it to the stack*/
  {
   
  eax=strint(argv[x]); /*get a number from the string*/
  if(strint_errors)
  {
   putstr("Last argument was not a number, but it could be a command!\n");
  }
  else
  {
   /*
   putstr("number returned by strint(argv[x]) is: ");
   putint(eax);
   putstr("\n");
   putstr("It will be pushed to the stack.");
   */
   push(eax);
  }
  
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


