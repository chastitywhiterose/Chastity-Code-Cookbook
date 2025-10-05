This program reads or writes bytes of a file.

To read a byte of a file:
enter the name and the hex address to read.

./fbyte 0.txt 0

To write instead of reading:
follow the address with hex byte values

./fbyte 0.txt 0 12 34 56

This works for any file as long as the file already exists to begin with.
The name 0.txt is only an example. I used a text file with this name during testing.

The purpose of this program is to be able to edit one or more bytes of a file without having to install or load up a graphical hex editor. This also allows for scripting the commands to arbitrarily modify files whenever needed.


---
# Compilation

Only the C standard library is used, as well as the "chasteint.h" header that I wrote. That library contains generally useful routines for converting between bases. Just compile with:

`gcc -Wall -ansi -pedantic main.c -o chastehex`

## History

This program is an improvement on "ckhexdump" which was a hexadecimal dumping program I wrote for fun. This one is better because it can function like this but can also edit individual bytes without any extra dependencies.
