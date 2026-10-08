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
 putstr("factorial sequence\n");

 a=api_new();
 b=api_new();
 c=api_new();

 api_set_ui(a,1);
 api_set_ui(b,1);
 api_set_ui(c,1);


 x=0;
 while(x<6)
 {
  api_shl(a);
  put_api(a); 
  putstr("\n");
  x++;
 }

 api_delete(a);
 api_delete(b);
 api_delete(c);

 return 0;
}
