#include <stdio.h>
#include <string.h>
#include "chastelib.h"
#include "chastdin.h"

#define stack_length 0x100
int stack[stack_length]; /*stack array of size stack_length*/

/*
variables named after registers

esp is declared as a pointer because its only purpose in Assembly is managing the stack
ebp is declared as a pointer to keep track of the original stack pointer address

all other registers are used as normal integers
real assembly language allows registers to be used interchangeably as numbers or pointers
this is one reason C is limited compared to Assembly.
*/
int eax,ebx,ecx,edx,esi,edi,*ebp,*esp;

/*
The push and pop instructions are written based on how Intel processors manage the stack with instructions of the same name.
That means the that esp goes downward when numbers are pushed to the stack and then up when numbers are popped off the stack and returned
This is the way Intel chose to do it but the reverse method would have worked just as well.
But regardless, these are not real registers and is only a simulation of Intel.
This program is of course portable to any processor because it is written in C.
*/

void push(i)
{
 esp--;
 *esp=i;
}

int pop()
{
 int i=*esp;
 *esp=0; /*optionally set the value at [esp] to 0 to mark as deleted*/
 esp++;
 return i;
}

int main(int argc, char **argv)
{
 char *s; /*character pointer for user input*/

 /*set the radix used for integer display*/
 radix=10;
 int_width=1;

 /*set the stack pointer to where it should start*/
  esp=stack+stack_length;
  ebp=esp; /*backup address of esp to ebp*/
  
putstr("chastdin is a stack based interactive calculator\n"
"Numbers are pushed on the stack and commands can do math.\n"
"It is a fork of chastack that reads from stdin instead of arguments.\n"
"Each line can contain multiple numbers or commands.\n"
"Math commands are add,sub,mul,div,rem\n"
"The exit command ends the program\n"
"The ? command prints the entire stack\n\n");

 last_char='\n'; /*set last_char to newline so prompt will print at start*/

 /*
 Each argument is processed as a number or command. The loop only ends when the "exit" command is entered.
 */

 while(1)
 {
  if(last_char=='\n')
  {
   putstr("-> ");
  }  
  s=getstring();
    
  /*first, we check for commands before we check for integers*/
  if(!strcmp(s,"exit"))
  {
   break;
  }

  if(!strcmp(s,"add"))
  {
   ebx=pop();
   eax=pop();
   eax+=ebx;
   push(eax);
  }
  
  else if(!strcmp(s,"mul"))
  {
   ebx=pop();
   eax=pop();
   eax*=ebx;
   push(eax);
  }

  else if(!strcmp(s,"sub"))
  {
   ebx=pop();
   eax=pop();
   eax-=ebx;
   push(eax);
  }

  else if(!strcmp(s,"div"))
  {
   ebx=pop();
   eax=pop();
   eax/=ebx;
   push(eax);
  }
  
  else if(!strcmp(s,"rem"))
  {
   ebx=pop();
   eax=pop();
   eax%=ebx;
   push(eax);
  }
  
  else if(!strcmp(s,"?"))
  {
   int *tmp=esp;
   while(esp<ebp)
   {
    putint(*esp); /*print whole stack in this loop*/  
    putstr("\n");
    esp++;
   }
   esp=tmp;
  }
  
  else if(!strcmp(s,"clear"))
  {
   while(esp<ebp)
   {
    pop(); /*erase whole stack in this loop*/  
   }
  }

  else /*try to get a number and push it to the stack*/
  {
   eax=strint(s); /*get a number from the string*/
   if(strint_errors)
   {
    putstr("Last argument was not a number, but it could be a command!\n");
   }
   else
   {
    push(eax);
   }
  }
  
 }

 return 0;
}
