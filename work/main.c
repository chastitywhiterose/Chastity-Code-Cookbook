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

 radix=10; /*set radix for integer output*/
 int_width=1; /*set default integer width*/

 if(argc==1)
 {
  putstring
  (
   "Welcome to chastehex! The tool for reading and writing bytes of a file!\n\n"
   "To hexdump an entire file:\n\n\tchastehex file\n\n"
   "To read a single byte at an address:\n\n\tchastehex file address\n\n"
   "To write a single byte at an address:\n\n\tchastehex file address value\n\n"
  );
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
   putstring(argv[1]);
   putstring("\n");
  }
 }

 if(argc==2)
 {
  hexdump(fp); /*hex dump if only filename given*/
 }

 if(argc>2)
 {
  x=strint(argv[2]);
  fseek(fp,x,SEEK_SET);
 }



 /*read a byte at address of second arg*/
 if(argc==3)
 {
  c=fgetc(fp);
  printf("%s ",intstr(x));
  if(c==EOF){printf("EOF\n");}
  else{printf("%s\n",intstr(c));}
 }

 /*any arguments past the address are hex bytes to be written*/
 if(argc>3)
 {
  argx=3;
  while(argx<argc)
  {
   c=strtol(argv[argx],NULL,16);
   printf("%s: ",intstr(x));
   printf("%s\n",intstr(c));
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
