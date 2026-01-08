#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "turing.h"
#include "nand.h"
int main(int argc, char *argv[])
{
 int a=3,b=5;
 putstring("Test of Bitwise Operations with standard C operators\n\n");
 turing_bitwise(a,b);

 putstring("Test of Bitwise Operations using only NAND function\n\n");
 
 turing_bitwise_nand(a,b);

 /*
 putstring("Same test but with both inputs inverted\n\n");
 a^=0xF;
 b^=0xF;
 turing_bitwise(a,b);
 */

 return 0;
}
