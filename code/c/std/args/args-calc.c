/*Command line arguments demo*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
int main(int argc, char **argv)
{
 int x,s_length;
 char *s; /*this will be used later as the master string*/
 char *tokens[0x100],*token,tokens_length,delim[]=" "; /*used for strtok later*/
 char *default_message="Run this program with arguments to display them to the console.";

 int *stack,stack_length=0x100,stack_index=0,i; /*stack variables*/

 printf("argc==%d\n",argc);

 if(argc==1)
 {
  printf("default: %s\n",default_message);
  return 0;
 }

 x=1;
 s_length=0;
 while(x<argc)
 {
  /*printf("argv[%i]: %s\n",x,argv[x]);*/
  s_length+=strlen(argv[x]);
  x++;
 }

 /*length of the characters in the arguments themselves*/
 printf("Length of arguments not counting spaces is %d\n",s_length);

 /*length if we assume one space between each argument*/
 printf("Length of arguments including spaces is %d\n",s_length+argc-2);

 /*allocates required length for string plus a little extra*/
 s=(char*)malloc(argc+s_length*sizeof(*s));if(s==NULL){printf("Failed to allocate main string a\n");return(1);}
 
 /*time to build the string from all the arguments*/

 strcpy(s,argv[1]); /*copy the first argument but do not add a space*/

 x=2;
 s_length=0;
 while(x<argc)
 {
  strcat(s," "); /*add a separator for each new argument after the first one*/
  strcat(s,argv[x]);
  x++;
 }

 puts("The final string is:");
 puts(s);

 /*get the final length after string is built*/
 s_length=strlen(s);

 printf("Length of final string: %d\n",s_length);

 /*
  now that the string is built, we will process it as numbers and words
  the strtok function was made for this kind of thing
 */

 /*loop for printing the tokens and saving them to an array but nothing else*/
 x=0;
 token = strtok(s,delim);
 while (token)
 {
  tokens[x]=token;
  printf("token[%d]: %s\n",x,tokens[x]);
  token = strtok(NULL, " ");
  x++;
 }
 tokens_length=x;

 printf("there are %d tokens\n",tokens_length);


stack=(int*)malloc(stack_length*sizeof(*stack));if(stack==NULL){printf("Failed to allocate integer stack a\n");return(1);}
 



 /*loop for processing the tokens as numbers or command words*/
 x=0;
 while (x<tokens_length)
 {
  printf("token[%d]: %s\n",x,tokens[x]);

  /* convert string to lowercase so that things operate regardless of caps lock */

  i=0;
  while(tokens[x][i]!=0)
  {
   tokens[x][i]=tolower(tokens[x][i]);
   i++;
  }

  if(isdigit(tokens[x][0]))
  {
   printf("token[%d]: %s might be a number\n",x,tokens[x]);

   if(tokens[x][1]=='b')
   {
    printf("This number might be a binary number.\n");
    printf("Processing with strtol, base two.\n");
    i=strtol(&tokens[x][2],NULL,2);
   }
   else
   {
    sscanf(tokens[x],"%i",&i);
   }

   printf("number found: %i (decimal form of this integer)\n",i);
   printf("it has been added to the stack\n");

   stack[stack_index]=i;
   stack_index++;
  }

  if(!strcmp(tokens[x],"add"))
  {
   printf("The add command adds the top two numbers on the stack.\n");
   if(stack_index>=2)
   {
    stack_index--;
    stack[stack_index-1]+=stack[stack_index];
   }
   else
   {
    printf("Error: Less than 2 numbers are on the stack. add command failed!\n");
   }
  }


  if(!strcmp(tokens[x],"mul"))
  {
   printf("The mul command multiplies the top two numbers on the stack.\n");
   if(stack_index>=2)
   {
    stack_index--;
    stack[stack_index-1]*=stack[stack_index];
   }
   else
   {
    printf("Error: Less than 2 numbers are on the stack. mul command failed!\n");
   }
  }


  if(!strcmp(tokens[x],"sub"))
  {
   printf("The sub command subtracts the top two numbers on the stack.\n");
   if(stack_index>=2)
   {
    stack_index--;
    stack[stack_index-1]-=stack[stack_index];
   }
   else
   {
    printf("Error: Less than 2 numbers are on the stack. sub command failed!\n");
   }
  }


  if(!strcmp(tokens[x],"div"))
  {
   printf("The div command divides the top two numbers on the stack.\n");
   if(stack_index>=2)
   {
    stack_index--;
    stack[stack_index-1]/=stack[stack_index];
   }
   else
   {
    printf("Error: Less than 2 numbers are on the stack. div command failed!\n");
   }
  }


  if(!strcmp(tokens[x],"mod"))
  {
   printf("The mod command divides the top two numbers on the stack but leaves the remainder of the division instead of the quotient\n");
   if(stack_index>=2)
   {
    stack_index--;
    stack[stack_index-1]%=stack[stack_index];
   }
   else
   {
    printf("Error: Less than 2 numbers are on the stack. mod command failed!\n");
   }
  }

  if(!strcmp(tokens[x],"debug"))
  {
   printf("This information is used to debug the program during development\n");

   printf("stack_index==%d\n",stack_index);

   i=0;
   while (i<stack_index)
   {
    printf("stack[%d]==%i\n",i,stack[i]);
    i++;
   }

  }


  x++;
 }


   i=0;
   while (i<stack_index)
   {
    printf("%i\n",stack[i]);
    i++;
   }











 if(s!=NULL){free(s); s=NULL;}
 if(stack!=NULL){free(stack); s=NULL;}

 return 0;
}
