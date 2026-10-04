#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-api.h"

int main(int argc, char *argv[])
{
 api a,b,c;

 radix=10;
 int_width=1;

 putstr("chastelib Arbitrary Precision Integer demo:\n");
 putstr("subtracting two integers\n");

 a=api_new();
 b=api_new();
 c=api_new();

 api_set_ui(a,1024);
 api_set_ui(b,768);

 api_mov(c,a); /*c=a*/
 api_sub(c,b); /*c-=b*/

 putstr("a="); put_api(a); putstr("\n");
 putstr("b="); put_api(b); putstr("\n");
 putstr("c="); put_api(c); putstr("\n");

 api_delete(a);
 api_delete(b);
 api_delete(c);

 return 0;
}
