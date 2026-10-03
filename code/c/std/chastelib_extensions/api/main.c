#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-api.h"

int main(int argc, char *argv[])
{
 struct api *a,*b;

 radix=10;
 int_width=1;

 putstr("chastelib Arbitrary Precision Integer demo:\n");
 putstr("adding two integers\n");

 a=api_new();
 b=api_new();

 api_set_ui(a,256);
 api_set_ui(b,512);

 put_api(a); putstr("\n");
 put_api(b); putstr("\n");


 return 0;
}

