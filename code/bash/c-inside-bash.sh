#!/bin/bash

cat > main.c << EOF
#include <stdio.h>
int main()
{
 printf("Hello, Linux Shell!\n");
 return 0;
}
EOF

gcc -Wall -ansi -pedantic main.c -o main && ./main

