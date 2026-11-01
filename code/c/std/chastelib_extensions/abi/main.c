#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-abi.h"

int main(int argc, char *argv[])
{
 abi a,b,c;

 putstr("chastelib Arbitrary Binary Integer demo:\n");
 putstr("add abi integers\n");
 
 init_length=8;

 a=abi_new();
 b=abi_new();
 c=abi_new();

 abi_set_ui(a,3);
 abi_set_ui(b,5);
 
 putstr("test case abi integers\n");

 putstr("A="); put_abi(a); putstr("\n");
 putstr("B="); put_abi(b); putstr("\n");
 
 putstr("adding abi integers\n");
 abi_mov(c,a);
 abi_add(c,b);
 putstr("A+B="); put_abi(c); putstr("\n");
 abi_mov(c,b);
 abi_add(c,a);
 putstr("B+A="); put_abi(c); putstr("\n");

 putstr("subtracting abi integers\n");
 abi_mov(c,a);
 abi_sub(c,b);
 putstr("A-B="); put_abi(c); putstr("\n");
 abi_mov(c,b);
 abi_sub(c,a);
 putstr("B-A="); put_abi_all(c); putstr("\n"); 

 abi_delete(a);
 abi_delete(b);
 abi_delete(c);

 return 0;
}
