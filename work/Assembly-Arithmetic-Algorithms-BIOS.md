# Assembly Arithmetic Algorithms

16-bit BIOS Edition

# Preface


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

