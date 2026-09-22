#include <stdio.h>
#include <gmp.h>
int main()
{
 char s[1024]; /*declare memory for a string*/
 mpz_t a,b;    /*declare variables of mpz_t integer type*/
 
 /*allocate memory for each of these variables*/
 mpz_init(a);
 mpz_init(b);
 
 /*set the initial value of them from regular C integers*/
 mpz_set_ui(a,32);
 mpz_set_ui(b,64);
 
 /*do an addition operation of a=a+b*/
 mpz_add(a,a,b);
 
 /*convert integer to a string in specific radix*/
 mpz_get_str (s,10,a);
 printf("%s\n",s);
 
 /*clear the memory of each variable*/
 mpz_clear(a);
 mpz_clear(b);
 
 return 0;
}

/* gcc -Wall -ansi -pedantic main.c -o main -lgmp && ./main */
