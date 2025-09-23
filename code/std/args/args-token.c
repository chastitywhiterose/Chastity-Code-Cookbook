/*Command line arguments demo*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char **argv)
{
 int x,s_length;
 char *s; /*this will be used later as the master string*/
 char *token,delim[]=" "; /*used for strtok later*/
 char *default_message="Run this program with arguments to display them to the console.";

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
  printf("argv[%i]: %s\n",x,argv[x]);
  s_length+=strlen(argv[x]);
  x++;
 }

 /*length of the characters in the arguments themselves*/
 printf("Length of arguments not counting spaces is %d\n",s_length);

 /*length if we assume one space between each argument*/
 printf("Length of arguments including spaces is %d\n",s_length+argc-2);

 /*allocates require length plus a little extra*/
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

 x=0;
 token = strtok(s,delim);
 while (token)
 {
  printf("token %d: %s\n",x,token);
  token = strtok(NULL, " ");
  x++;
 }




















 if(s!=NULL){free(s); s=NULL;}

 return 0;
}
