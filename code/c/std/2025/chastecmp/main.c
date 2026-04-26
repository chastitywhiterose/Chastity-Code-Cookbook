#include <stdio.h>
#include <stdlib.h>
 
int main(int argc, char *argv[])
{
 int argx,x;
 FILE* fp[3]; /*file pointers*/
 int c1,c2;
 long flength[3]; /*length of the file opened*/
   
 /*printf("argc=%i\n",argc);*/

 if(argc<3)
 {
  printf("Welcome to Chastity's Hex Compare program also known as \"chastecmp\".\n\n");
  printf("Enter two filenames as command line arguments such as:\n");
  printf("%s file1.txt file2.txt\n",argv[0]);
  return 0;
 }

 argx=1;
 while(argx<3)
 {
   fp[argx] = fopen(argv[argx], "rb"); /*Try to open the file.*/
   if(!fp[argx]) /*If the pointer is NULL then this becomes true and the file open has failed!*/
   {
    printf("Error: Cannot open file \"%s\": ",argv[argx]);
    printf("No such file or directory\n");
    return 1;
   }
  /*printf("File \"%s\": opened.\n",argv[argx]);*/

  printf("fp[%X] = fopen(\"%s\", \"rb\");\n",argx,argv[argx]);
  argx++;
 }

 printf("Comparing files %s and %s\n",argv[1],argv[2]);

 argx=1;
 while(argx<3)
 {
  fseek(fp[argx],0,SEEK_END); /*go to end of file*/
  flength[argx]=ftell(fp[argx]); /*get position of the file*/
  printf("length of file fp[%X]=%lX\n",argx,flength[argx]);
  fseek(fp[argx],0,SEEK_SET); /*go back to the beginning*/
  argx++;
 }

 x=0;
 while(x<flength[1])
 {
  c1 = fgetc(fp[1]);
  c2 = fgetc(fp[2]);
  if(c1!=c2)
  {
   printf("%08X: %02X %02X\n",x,c1,c2);
  }
  x++;  
 }

 argx=1;
 while(argx<3)
 {
  fclose(fp[argx]);
  printf("fclose(fp[%X]);\n",argx);
  argx++;
 }

 return 0;
}
