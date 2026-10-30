#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-abi.h"

int main(int argc, char *argv[])
{
 abi a,b,c;

 putstr("chastelib Arbitrary Binary Integer demo:\n");
 putstr("add abi integers\n");

 a=abi_new();
 b=abi_new();
 c=abi_new();

 abi_set_ui(a,3);
 abi_set_ui(b,5);
 
 abi_mov(c,a);
 abi_add(c,b);

 put_abi_all(a); putstr("\n");
 put_abi_all(b); putstr("\n");
 put_abi_all(c); putstr("\n");
 

 abi_delete(a);
 abi_delete(b);
 abi_delete(c);

 return 0;
}
