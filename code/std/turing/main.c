#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "turing.h"
int main(int argc, char *argv[])
{
 int a=3,b=5;
 turing_bitwise(a,b);
 a^=0xF;
 b^=0xF;
 /*turing_bitwise(a,b);*/

 return 0;
}
