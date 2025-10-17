#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"

void hexdump(FILE* fp)
{
 int x,c,address=0,width=16;
 x=0;
 while ((c = fgetc(fp)) != EOF)
 {
  if(x%width==0)
  {
   printf("%08X ",address);
  }
  
  printf("%02X",c);
  x++;

  if(x==width){printf("\n");x=0;}
  else{printf(" ");}
   
  address++;
 }
 if(x!=width){printf("\n");}
}
 
int main(int argc, char *argv[])
{
 int argx,x,c;
 FILE* fp; /*file pointer*/
   
 /*printf("argc=%i\n",argc);*/

 if(argc==1)
 {
  printf("Chastity's Hexadecimal Tool\n\n");
  printf("This program reads or writes bytes of a file.\n\n");
  printf("Read Usage Type 1: (hexdump entire file)\n %s file\n\n",argv[0]);
  printf("Read Usage Type 2: (read one byte from this address)\n %s file address \n\n",argv[0]);
  printf("Write Usage: (write one or more bytes to this address)\n %s file address byte\n",argv[0]);
  return 0;
 }

 if(argc>1)
 {
  fp=fopen(argv[1],"rb+");
  if(fp==NULL)
  {
   printf("File \"%s\" does not exist.\n",argv[1]);
   return 1;
  }
  else
  {
   printf("fp=fopen(\"%s\",\"rb+\")\n",argv[1]);
  }
 }

 if(argc==2)
 {
  hexdump(fp); /*hex dump if only filename given*/
 }

 if(argc>2)
 {
  x=strint(argv[2],16);
  fseek(fp,x,SEEK_SET);
 }



 /*read a byte at address of second arg*/
 if(argc==3)
 {
  c=fgetc(fp);
  printf("%s ",intstr(x,16,8));
  if(c==EOF){printf("EOF\n");}
  else{printf("%s\n",intstr(c,16,2));}
 }

 /*any arguments past the address are hex bytes to be written*/
 if(argc>3)
 {
  argx=3;
  while(argx<argc)
  {
   c=strtol(argv[argx],NULL,16);
   printf("%s: ",intstr(x,16,8));
   printf("%s\n",intstr(c,16,2));
   fputc(c,fp);
   x++;
   argx++;
  }
 }
 
 printf("fclose(fp);\n");
 fclose(fp);
 return 0;
}

/* gcc -Wall -ansi -pedantic main.c -o chastehex */
