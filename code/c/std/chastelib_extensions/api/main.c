#include <stdio.h>
#include <stdlib.h>
#include "chastelib.h"
#include "chastelib-api.h"

int main(int argc, char *argv[])
{
 struct api *a;

 radix=10;
 int_width=1;

 putstr("chastelib Arbitrary Precision Integer demo\n");

 a=api_new();

 put_api(a);
 putstr("\n");

 return 0;
}

