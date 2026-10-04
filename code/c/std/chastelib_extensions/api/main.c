#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-api.h"

int main(int argc, char *argv[])
{
 int x;
 api a,b,c;

 radix=10;
 int_width=1;

 putstr("chastelib Arbitrary Precision Integer demo:\n");
 putstr("subtracting two integers\n");

 a=api_new();
 b=api_new();
 c=api_new();

 api_set_ui(a,1);
 api_set_ui(b,1);
 api_set_ui(c,1);

 x=0;
 while(x<64)
 {
  api_mul(a,b);
  put_api(b); 
  putstr("! = "); put_api(a); putstr("\n");
  api_add(b,c);
  x++;
 }

 api_delete(a);
 api_delete(b);
 api_delete(c);

 return 0;
}
