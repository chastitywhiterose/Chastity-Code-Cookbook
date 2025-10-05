#include <stdio.h>
#include "chasteint.h"

int main(int argc, char **argv)
{
 if(argc==1)
 {
  printf("Welcome to Chastity's STRing to INTeger program.\nThis program converts strings in any base from 2 to 36.");
  printf("For example, you could enter\n\t \"%s 11111000011\"\n to see the conversion of the year I was born.\n",argv[0]);
  printf("The default base is binary (base 2).\n");
  printf("To get the exact same result but entering the year in decimal, enter\n\t\"%s 1987 10\"\n",argv[0]);
  printf("This information is nerdy but also proves that strings can be converted in C\n");
  /*debug();*/
 }
 if(argc==2){ strint_test(argv[1],2); }
 if(argc==3){ strint_test(argv[1],strint(argv[2],10)); }

 return 0;
}
