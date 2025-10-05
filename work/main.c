/* gcc fhex.c -o fhex -Wall -ansi -pedantic && ./fhex */

#include <stdio.h>
#include <stdlib.h>

#define usl 256
char us[usl+1]; /*global string which will be used to store string of integers*/

char* ltostr(long i,int base,int width)
{
 char *s=us+usl;
 *s=0;
 do
 {
  s--;
  *s=i%base;
  i/=base;
  if(*s<10){*s+='0';}else{*s=*s-10+'A';}
  width--;
 }
 while(i!=0 || width>0);
 return s;
}
 
int main(int argc, char *argv[])
{
 long argx,x,c;
 FILE* fp; /*file pointer*/
   
 /*printf("argc=%i\n",argc);*/

 if(argc==1)
 {
  printf("This program reads or writes bytes of a file.\n\n");
  printf("Read Usage:\n %s file address\n\n",argv[0]);
  printf("Write Usage:\n %s file address byte\n\n",argv[0]);
  return 1;
 }

 if(argc>1)
 {
  fp=fopen(argv[1],"rb+");
  if(fp==NULL)
  {
   printf("File %s does not exist.\n",argv[1]);
   printf("Attempting to create file\n");
   fp=fopen(argv[1],"wb+");
   if(fp==NULL){printf("Failed to create file \"%s\".\n",argv[1]);}
  }
  else
  {
   printf("File \"%s\" opened.\n",argv[1]);
  }
 }

 if(argc>2)
 {
  x=strtol(argv[2],NULL,16);
  fseek(fp,x,SEEK_SET);
 }

 if(argc==3)
 {
  c=fgetc(fp);
  printf("%s: ",ltostr(x,16,8));
  if(c==EOF){printf("EOF\n");}else{printf("%s\n",ltostr(c,16,2));}
 }

 if(argc>3)
 {
  argx=3;
  while(argx<argc)
  {
   c=strtol(argv[argx],NULL,16);
   printf("%s: ",ltostr(x,16,8));
   if(c==EOF){printf("EOF\n");}else{printf("%s\n",ltostr(c,16,2));}
   fputc(c,fp);
   x++;
   argx++;
  }
 }
 

 fclose(fp);
 return 0;
}


/*
This program reads or writes bytes of a file.

To read a byte of a file:
enter the name and the hex address to read.

./fbyte 0.txt 0

To write instead of reading:
follow the address with hex byte values

./fbyte 0.txt 0 12 34 56

This works for any file as long as the file already exists to begin with.
The name 0.txt is only an example. I used a text file with this name during testing.
*/
