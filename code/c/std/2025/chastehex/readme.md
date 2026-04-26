# Chastity's Hexadecimal Tool

This program reads or writes bytes of a file.

Read Usage Type 1: (hexdump entire file)
 ./main file

Read Usage Type 2: (read one byte from this address)
 ./main file address 

Write Usage: (write one or more bytes to this address)
 ./main file address byte

---

This works for any file as long as the file already exists to begin with. As usual, back up your files first to avoid losing any data!

The purpose of this program is to be able to edit one or more bytes of a file without having to install or load up a graphical hex editor. This also allows for scripting the commands to arbitrarily modify files whenever needed.


---
## Compilation

Only the C standard library is used, as well as the "chasteint.h" header that I wrote. That library contains generally useful routines for converting between bases. Just compile with:

`gcc -Wall -ansi -pedantic main.c -o chastehex`

## History

This program is an improvement on "ckhexdump" which was a hexadecimal dumping program I wrote for fun. This one is better because it can function like this but can also edit individual bytes without any extra dependencies.

There are many hex dumping programs out there but I believe mine goes a step ahead because it allows editing bytes of files using shell scripts, for example, empty space in executable files, or perhaps to modify the behavior of video games.

## Why would I use this?

Because although there are many hex editors available for Linux, the dependency chain of Graphical User Interfaces requires more time installing packages that are not needed if you only want to edit a few bytes of a binary file.

Of course, for manual editing, you can probably find a better tool, but this one only requires the C library to be linked, which is the default for all C programs anyway.
