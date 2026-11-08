# Assembly Arithmetic Algorithms

16-bit BIOS Edition

# Preface

This book is meant to serve as an tutorial for those who have read my 16-bit DOS edition of Assembly Arithmetic Algorithms.

It is recommended, but not required, to read the DOS book first because I already explained Assembly language for the 16 bit Intel CPU descendants of the 8086 processor. An understanding of this language is recommended to get the most benefit of this book.

However, because I give full working code examples and the means to Assemble and run these programs, you can copy and paste (or retype if you wish) these examples just for a greater understanding of the boot process of a computer.

All examples run under the BIOS and do not require an operating system such as DOS, Linux, or Windows to run. However, you will need an operating system to run the QEMU PC emulator to load the programs onto a virtual computer that behaves like a computer at the stage where the BIOS detects hardware and tries to load your boot sector program instead of an operating system.

Because QEMU is Open Source and available for modern Linux or Windows, it will be as convenient to use as DOSBox was in the DOS version of Assembly Arithmetic Algorithms.


# Chapter 1: Hello World

My first example will be displaying a message to the screen. Believe it or not, this is possible to do with a BIOS interrupt right from the start. The following putstring function will be used in the program using function 0xE of BIOS interrupt 0x10 which displays a character.

The text to the right of the semicolons are comments meant to explain my reasoning while writing the function, but are ignored by the assembler and only there for human benefit.

## putstring-bios.asm

```
putstring:

push ax
push bx
mov bx,ax                  ;copy ax to bx to be used as index to the string
mov ah,0xE                 ;Select Function 0xE for interrupt 0x10
putstring_strlen_start:    ;this loop finds the length of the string as part of the putstring function
cmp byte[bx],0             ;compare this byte with 0
jz putstring_strlen_end    ;if comparison was zero, jump to loop end because we have found the length
mov al,[bx]                ;load al register with this character
int 0x10                   ;call the BIOS to print this character
inc bx
jmp putstring_strlen_start ;jump to the start of the loop and keep trying until we find a zero
putstring_strlen_end:
pop bx
pop ax

ret
```

The function should be saved in a file named "putstring-bios.asm" because it will be reused throughout this book. The putstring function is not a complete program by itself because we have not given it a string to print nor have we even written the main function.

The main function will be in a file named "main.asm" as is my usual convention for all my Assembly books.

## main.asm

```
```

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

