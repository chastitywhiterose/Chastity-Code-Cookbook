# chastelib C++ Edition iostream

This version of chastelib contains the same functions as the C version. However, the output for putstring has been changed to use std::cout as the standard output stream instead of stdout from the C language.

As long as you `#include <iostream>` instead of `#include <stdio.h>`, then everything should work in C++ the same as it did in C.

But keep in mind this won't compile unless using a valid C++ compiler like g++. A regular C compiler won't work and you will need the C version of this header.
