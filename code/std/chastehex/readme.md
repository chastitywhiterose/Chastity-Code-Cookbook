# Chastity's Hexadecimal Tool

This program reads or writes bytes of a file.

Read Usage Type 1:
 ./chastehex file (hexdump entire file)

Read Usage Type 2:
 ./chastehex file address (read one byte from this address)

Write Usage:
 ./chastehex file address byte (write byte(s) to this address)

---

This works for any file as long as the file already exists to begin with. As usual, back up your files first to avoid losing any data!

The purpose of this program is to be able to edit one or more bytes of a file without having to install or load up a graphical hex editor. This also allows for scripting the commands to arbitrarily modify files whenever needed.


---
## Compilation

Only the C standard library is used, as well as the "chasteint.h" header that I wrote. That library contains generally useful routines for converting between bases. Just compile with:

`gcc -Wall -ansi -pedantic main.c -o chastehex`

## History

This program is an improvement on "ckhexdump" which was a hexadecimal dumping program I wrote for fun. This one is better because it can function like this but can also edit individual bytes without any extra dependencies.
