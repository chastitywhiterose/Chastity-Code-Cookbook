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

char *s; /*character pointer for user input*/

/*
 this function is called by all math commands that requires two or more numbers
 to be on the stack when they are used.
*/ 
void stack_check()
{
 if(ebp>stack)
 {
  *(ebp+1)=0; /*erase old top of stack because command was successful*/
 }
 else
 {
  putstr("Error: two numbers required for command: ");
  putstr(s);
  putstr("\n");
  ebp++; /*increment the pointer to what it was before the failed command*/
 }
}

int main(int argc, char **argv)
{


 /*set the radix used for integer display*/
 radix=10;
 int_width=1;

 /*set the base pointer to where it should start*/
  ebp=stack;
  
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
   ebx=*ebp;
   ebp--;
   eax=*ebp;
   eax+=ebx;
   *ebp=eax;
   stack_check();
  }
  
  else if(!strcmp(s,"sub"))
  {
   ebx=*ebp;
   ebp--;
   eax=*ebp;
   eax-=ebx;
   *ebp=eax;
   stack_check();
  }
  
  else if(!strcmp(s,"mul"))
  {
   ebx=*ebp;
   ebp--;
   eax=*ebp;
   eax*=ebx;
   *ebp=eax;
   stack_check();
  }

  else if(!strcmp(s,"div"))
  {
   ebx=*ebp;
   ebp--;
   eax=*ebp;
   eax/=ebx;
   *ebp=eax;
   stack_check();
  }
  
  else if(!strcmp(s,"rem"))
  {
   ebx=*ebp;
   ebp--;
   eax=*ebp;
   eax%=ebx;
   *ebp=eax;
   stack_check();
  }
  
  else if(!strcmp(s,"?"))
  {
   int *tmp=ebp;
   while(ebp>stack)
   {
    putint(*ebp); /*print whole stack in this loop*/  
    putstr("\n");
    ebp--;
   }
   ebp=tmp;
  }
  
  else if(!strcmp(s,"clear"))
  {
   while(ebp>stack)
   {
    ebp--; /*erase whole stack in this loop*/  
   }
  }

  else /*try to get a number and push it to the stack*/
  {
   eax=strint(s); /*get a number from the string*/
   if(strint_errors)
   {
    putstr("Last argument was not a number, but it could be a command!\n");
   }
   else if(read_count==0)
   {
    /*nothing happens because no characters were read*/
   }
   else
   {
    ebp++;
    *ebp=eax;
   }
  }
  
 }

 return 0;
}

