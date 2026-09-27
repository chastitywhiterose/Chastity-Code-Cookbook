#include <stdio.h>
#include <string.h>
#include "chastelib.h"
#include "chastdin.h"

#include <gmp.h>

#define stack_length 0x100
mpz_t stack[stack_length]; /*stack array of size stack_length*/

char outstr[0x1000000]; /*large space for string form of mpz conversion*/

int stack_length_init=4;
int stack_index=0;

/*
variables named after registers

esp is declared as a pointer because its only purpose in Assembly is managing the stack
ebp is declared as a pointer to keep track of the original stack pointer address

all other registers are used as normal integers
real assembly language allows registers to be used interchangeably as numbers or pointers
this is one reason C is limited compared to Assembly.
*/


char *s; /*character pointer for user input*/

void help()
{
 putstr
 (
  "chastdin is a stack based interactive calculator\n"
  "Numbers are pushed on the stack and commands can do math.\n"
  "It is a fork of chastack that reads from stdin instead of arguments.\n"
  "Each line can contain multiple numbers or commands.\n\n"
  "Math commands are add,sub,mul,div,rem\n"
  "And use the top two stack numbers for their operations\n\n"

  "The setradix command uses the top of stack as the new radix\n"
  "The exit command ends the program\n"
  "The ? command prints the entire stack\n\n"
 );
}

/*
 This function is called by all math commands that require two or more numbers
 to be on the stack when they are used.
*/ 
void stack_check()
{
 if(stack_index>0)
 {
  /*erase old top of stack with zero*/
  mpz_set_ui(stack[stack_index+1],0); 
 }
 else
 {
  putstr("Error: two numbers required for command: ");
  putstr(s);
  putstr("\n");
  stack_index++; /*increment the pointer to what it was before the failed command*/
 }
}

int main(int argc, char **argv)
{
 int x;/*,y*/
 
 /*initialize the mpz stack array*/
 x=0;
 while(x<=stack_length_init)
 {
  mpz_init(stack[x]);
  x++;
 }

 /*set the radix used for integer display*/
 radix=10;
 int_width=1;

 help();

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
  
  if(!strcmp(s,"help"))
  {
   help();
  }
  
  else if(!strcmp(s,"setradix"))
  {

  }

  else if(!strcmp(s,"add"))
  {
   stack_index--;
   mpz_add(stack[stack_index],stack[stack_index],stack[stack_index+1]);
   stack_check();
  }
  
  else if(!strcmp(s,"sub"))
  {
   stack_index--;
   mpz_sub(stack[stack_index],stack[stack_index],stack[stack_index+1]);
   stack_check();
  }
  
  else if(!strcmp(s,"mul"))
  {
   stack_index--;
   mpz_mul(stack[stack_index],stack[stack_index],stack[stack_index+1]);
   stack_check();
  }

  else if(!strcmp(s,"div"))
  {
   stack_index--;
   mpz_tdiv_q(stack[stack_index],stack[stack_index],stack[stack_index+1]);
   stack_check();
  }
  
  else if(!strcmp(s,"rem"))
  {
   stack_index--;
   mpz_tdiv_q(stack[stack_index],stack[stack_index],stack[stack_index+1]);
   stack_check();
  }
  
  else if(!strcmp(s,"?"))
  {
   x=stack_index;
   while(x>0)
   {
    /*convert integer to a string in specific radix*/
    mpz_get_str(outstr,10,stack[x]);
    putstr(outstr); /*print the outstr*/  
    putstr("\n");
    x--;
   }
  }
  
  else if(!strcmp(s,"clear"))
  {

  }

  /*
   if the string matches none of the commands above
   try to get a number and push it to the stack
   using the current radix and the strint function
  */
  else
  {
   x=strint(s); /*get a number from the string*/
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
    stack_index++;
    /*init more memory only if necessary*/
    if(stack_index>stack_length_init)
    {
     printf("stack_index=%d\n",stack_index);
     mpz_init(stack[stack_index]);
     putstr("mpz_init(stack[stack_index]);\n");
     stack_length_init++;
    }
    /*set this mpz equal to integer returned from strint*/
    mpz_set_ui(stack[stack_index],x);
   }
  }
  
 }
 
 /*clear the mpz stack array*/
 x=0;
 while(x<=stack_length_init)
 {
  mpz_clear(stack[x]);
  x++;
 }


 return 0;
}

