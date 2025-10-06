#include <stdio.h>
#include <stdlib.h>


void hexdump(FILE* fp)
{
 int x,c,address=0,width=16;
 x=0;
 while ((c = fgetc(fp)) != EOF)
 {
  if(x%width==0)
  {
   printf("%08X: ",address);
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
  printf("Read Usage Type 1:\n %s file (hexdump entire file)\n\n",argv[0]);
  printf("Read Usage Type 2:\n %s file address (read one byte from this address)\n\n",argv[0]);
  printf("Write Usage:\n %s file address byte (write byte(s) to this address)\n",argv[0]);
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
   printf("File \"%s\" opened.\n",argv[1]);
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

 if(argc==3)
 {
  c=fgetc(fp);
  printf("%08X\n",x);
  if(c==EOF){printf("EOF\n");}
  else{printf("%02X\n",c);}}
 }

 if(argc>3)
 {
  argx=3;
  while(argx<argc)
  {
   c=strtol(argv[argx],NULL,16);
   printf("%08X\n",x);
   printf("%02X\n",c);
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