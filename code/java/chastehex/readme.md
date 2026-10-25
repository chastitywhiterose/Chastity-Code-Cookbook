# Chastity's Hexadecimal Tool Java Edition

This program reads or writes bytes of a file.

To hexdump an entire file:

	java chastehex file

To read a single byte at an address:

	java chastehex file address

To write a single byte at an address:

	java chastehex file address value

---

This works for any file as long as the file already exists to begin with. As usual, back up your files first to avoid losing any data!

The purpose of this program is to be able to edit one or more bytes of a file without having to install or load up a graphical hex editor. This also allows for scripting the commands to arbitrarily modify files whenever needed.


---
## Compilation

Because only the Java Development kit is used, compiling and running in one go is as easy as this command:
```
javac chastehex.java && java chastehex
```

## History

This program is an improvement on "ckhexdump" which was a hexadecimal dumping program I wrote for fun. This one is better because it can function like this but can also edit individual bytes without any extra dependencies.

There are many hex dumping programs out there but I believe mine goes a step ahead because it allows editing bytes of files using shell scripts, for example, empty space in executable files, or perhaps to modify the behavior of video games.

## Why would I use this?

Because although there are many hex editors available for Linux, the dependency chain of Graphical User Interfaces requires more time installing packages that are not needed if you only want to edit a few bytes of a binary file.

The original and most reliable version of chastehex is still written in C, but because Java is also really old, I decided to make this special Java version of chastehex. People who like Java better may learn from my techniques in how the program is built.
