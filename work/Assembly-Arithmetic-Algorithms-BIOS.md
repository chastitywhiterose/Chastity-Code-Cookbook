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
org 0x7C00

main:

mov ax,string0
call putstring

jmp $

string0 db 'Hello World',0xD,0xA,0

include 'putstring-bios.asm'

times 510-($-$$) db 0
dw 0xAA55
```

The "org 0x7C00" tells the assembler that the code begins running at 0x7C00 when the BIOS loads the hard disk. I did not choose this address but the assembler must be informed so references to memory are correct.

The main function begins at the label "main:" and ends at the instruction "jmp $". This is an infinite loop that jumps to itself. Because this program is run at boot and there is no operating system to "return" or "exit" to, then the program must stay in this infinite loop or the emulator (or real PC if you tried to use one) won't know what to do.

The only thing happening inside the main function are these two lines:

```
mov ax,string0
call putstring
```

This loads the ax register with the memory location where string0 starts. The string is defined by the line:

```
string0 db 'Hello World',0xD,0xA,0
```

Finally, we must include the putstring function written earlier as part of this program. Assembly is much like the C Programming Language because you can include external files in your program just like this:

```
include 'putstring-bios.asm'
```

Every part of the program is written now, but there is one more step. We must tell the computer that the file is executable (can run as a program). Fortunately, this is easy to do.

The following two lines serve a special purpose. They ensure that the binary output file is recognized by the BIOS as a valid bootable hard disk. Now all disks are marked as bootable.

To mark a disk as bootable, the last two bytes of the first 512 byte sector must be "55 AA"

```
times 510-($-$$) db 0
dw 0xAA55
```

Those commands will fill the extra space with zeros and then finish with the correct bytes.

The times macro, which has been used in the NASM Assembly seems to be supported in the latest version of FASM. I have successfully assembled it with both the FASM and NASM Assemblers.

**NASM Note**: When assembling with NASM, you will need to use a percent sign with the include directive like this:

```
%include 'putstring-bios.asm'
```

And the command to assemble will be this:

```
nasm main.asm -o main.bin
```

