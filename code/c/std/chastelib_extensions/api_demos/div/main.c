#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-api.h"

int main(int argc, char *argv[])
{
 api a,b,c,d;

 radix=10;
 int_width=1;

 putstr("chastelib Arbitrary Precision Integer demo:\n");
 putstr("dividing api integers\n");

 a=api_new();
 b=api_new();
 c=api_new();
 d=api_new();


 api_set_ui(a,65536);
 api_set_ui(b,100);
 api_set_ui(c,1);

 api_mov(c,a);
 api_mov(d,a);

 api_div(c,b);
 api_rem(d,b);

 put_api(a); putstr("\n");
 put_api(b); putstr("\n");
 put_api(c); putstr("\n");
 put_api(d); putstr("\n");
 

 api_delete(a);
 api_delete(b);
 api_delete(c);
 api_delete(d);

 return 0;
}
