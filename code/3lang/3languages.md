# 3 Programming Languages for Beginners

After writing my books on Assembly language, I was thinking to myself just how much work it takes to get something working in Assembly compared to the programming languages I learned with.

I would like to take you on a journey of how programmers like me learned things in the 20th century. To do this, I will be briefly describing my top 3 favorite historical programming languages in the order they were first created.

- 1964 BASIC
- 1970 Pascal
- 1972 C

## Basic Hello World

```
print "Hello World!"
/'
 This is a Basic program.
 It prints a hello message.

 compile and run as:

 fbc main.bas && ./main
'/
```

## Pascal Hello World

```
program main;
begin
 writeLn('Hello World!');
end.
(*
 This is a Pascal program.
 It prints a hello message.

 compile and run as:

 fpc main.pas && ./main
*)
```

## C Hello World

```
#include <stdio.h>
int main()
{
 printf("Hello World!\n");
 return 0;
}
/*
 This is a C program.
 It prints a hello message.

 compile and run as:

 gcc main.c -o main && ./main
*/
```

# Online References