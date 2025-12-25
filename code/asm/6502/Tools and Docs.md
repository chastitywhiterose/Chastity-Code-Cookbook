# Resources for learning 6502 Assembly.

<https://skilldrick.github.io/easy6502/>

<http://www.6502.org/tutorials/6502opcodes.html>

<https://www.assemblytutorial.com/6502/>

## Assemblers

<https://github.com/parasyte/asm6>

<http://www.compilers.de/vasm.html>

## Emulators:

<http://www.wsxyz.net/sim65/> (requires wxwidgets but I compiled it from the source on my Debian Linux)

<https://github.com/sethm/symon> (a java based simulator that is easy to use)

## Debian Packages

These are tools I have installed on Debian Linux. The list is obtained with:


`apt search 6502`


```
Sorting... Done
Full Text Search... Done
64tass/oldstable,now 1.58.2974-1 amd64 [installed]
  cross (turbo) assembler targeting the MOS 65xx series of micro processors

acme/oldstable,now 1:0.97~svn20211115+ds-1+b1 amd64 [installed]
  Multi-platform cross assembler for 6502/6510/65816 CPU

cc65/oldstable,now 2.19-1 amd64 [installed]
  complete cross development package for 65(C)02 systems

crasm/oldstable,now 1.8-3 amd64 [installed]
  Cross assembler for 6800/6801/6803/6502/65C02/Z80

dasm/oldstable,now 2.20.15~20201109+really2.20.14.1-2 amd64 [installed]
  Macro assembler with support for several 8-bit microprocessors

xa65/oldstable,now 2.3.14-0.1 amd64 [installed]
  cross-assembler and utility suite for 65xx/65816 processors

xscreensaver-data/oldstable,now 6.06+dfsg1-3+deb12u1 amd64 [installed]
  Screen saver modules for screensaver frontends
```

I have found xa and 64tass to be the best assemblers for compatibility with the Easy6502 tutorial.

xa main.asm -o main.bin

64tass main.asm -o main.bin -b

---

# Progress

I will document what I have learned so far about 6502 Assembly here.
