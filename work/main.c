#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "chastelib.h"

int main(int argc, char *argv[])
{
 char buffer[0x100]; /*buffer of characters to store things we are not printing yet*/
 char *bp=buffer;    /*bp stands for buffer pointer*/
 
 strcpy(bp,"Hello Jason");  /*copy initial string to address of pointer*/
 bp+=strlen(bp);            /*find the length of this string and update bp to point to the end*/
 strcpy(bp," and Jeffery\n"); /*copy string to where bp points now*/
 putstring(buffer);         /*print entire buffer*/

 return 0;
}

