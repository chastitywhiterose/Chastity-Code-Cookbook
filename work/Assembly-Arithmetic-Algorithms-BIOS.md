# Assembly Arithmetic Algorithms

16-bit BIOS Edition

# Preface

This book is meant to serve as an tutorial for those who have read my 16-bit DOS edition of Assembly Arithmetic Algorithms.

It is recommended, but not required, to read the DOS book first because I already explained Assembly language for the 16 bit Intel CPU descendants of the 8086 processor. An understanding of this language is recommended to get the most benefit of this book.

However, because I give full working code examples and the means to Assemble and run these programs, you can copy and paste (or retype if you wish) these examples just for a greater understanding of the boot process of a computer.

All examples run under the BIOS and do not require an operating system such as DOS, Linux, or Windows to run. However, you will need an operating system to run the QEMU PC emulator to load the programs onto a virtual computer that behaves like a computer at the stage where the BIOS detects hardware and tries to load your boot sector program instead of an operating system.

Because QEMU is Open Source and available for modern Linux or Windows, it will be as convenient to use as DOSBox was in the DOS version of Assembly Arithmetic Algorithms.


# Chapter 1: Hello World



The following two lines serve a special purpose. They ensure that the binary output file is recognized by the BIOS as a valid bootable hard disk. Now all disks are marked as bootable.

To mark a disk as bootable, the last two bytes of the first 512 byte sector must be "55 AA"

```
times 510-($-$$) db 0
dw 0xAA55
```

The times macro, which has been used in the NASM Assembly seems to be supported in the latest version of FASM. I have successfully assembled it with both the FASM and NASM Assemblers.

Note that when assembling with NASM, you will need to use a percent sign with the include directive like this:

```
%include 'putstring-bios.asm'
```

And the command to assemble will be this:

```
nasm main.asm -o main.bin
```

