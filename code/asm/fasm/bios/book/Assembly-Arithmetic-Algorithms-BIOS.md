# Assembly Arithmetic Algorithms

16-bit BIOS Edition

# Preface

This book is meant to serve as an tutorial for those who have read my 16-bit DOS edition of Assembly Arithmetic Algorithms. If you have not read it yet, you can find it in both ebook and paperback editions:

<https://leanpub.com/assemblyarithmeticalgorithms-dos>

<https://www.projectqpub.com/books/assembly-arithmetic-algorithms>

It is recommended, but not required, to read the DOS book first because I already explained Assembly language for the 16 bit Intel CPU descendants of the 8086 processor. An understanding of this language is recommended to get the most benefit of this book.

However, because I give full working code examples and the means to Assemble and run these programs, you can copy and paste (or retype if you wish) these examples just for a greater understanding of the boot process of a computer. You won't need experience in programming but you will need to know how to install and use fasm or nasm for an assembler.

All examples run under the BIOS and do not require an operating system such as DOS, Linux, or Windows to run. However, you will need an operating system to run the QEMU PC emulator to load the programs onto a virtual computer that behaves like a computer at the stage where the BIOS detects hardware and tries to load your boot sector program instead of an operating system.

Because QEMU is Open Source and available for modern Linux or Windows, it will be as convenient to use as DOSBox was in the DOS version of Assembly Arithmetic Algorithms.

Other PC emulators like Oracle VirtualBox should also work equally well if you configure them to boot the file we will be creating in chapter 1.


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

The following two lines serve a special purpose. They ensure that the binary output file is recognized by the BIOS as a valid bootable hard disk. Not all disks are marked as bootable. To mark a disk as bootable, the last two bytes of the first 512 byte sector must be "55 AA"

```
times 510-($-$$) db 0
dw 0xAA55
```

Those commands will fill the extra space with zeros and then finish with the correct bytes.

Instead of the "times" directive, it is also possible to use a "dup" statement as part of data declaration.

```
db 510-($-$$) dup 0
```

Whichever you use, both **dup** and **times** are supported by the FASM and NASM assemblers. I know this because I have successfully assembled the same source code with both the FASM and NASM Assemblers.

There is one key difference though. See the note below if you are using NASM instead of FASM.

**NASM Note**: When assembling with NASM, you will need to use a percent sign with the include directive because NASM requires it. Do it like this:

```
%include 'putstring-bios.asm'
```

Once you have your source ready, the command to assemble will be this:

```
nasm main.asm -o main.bin
```

And the final step is to run it with QEMU. You have two options. Either the 32-bit emulator:

```
qemu-system-i386 -drive file=main.bin,format=raw
```

Or the 64-bit emulator:

```
qemu-system-x86_64 -drive file=main.bin,format=raw
```

In the end it doesn't matter which you use because the Assembly code is for 16-bit real mode which is the same as was used in the DOS book and it is the default mode the CPU boots into when you turn on a computer.

When you boot the main.bin file in QEMU, you will see something like:

```
Booting from Hard Disk...
Hello World
```

If you see this, it means that the putstring function I wrote for the BIOS is working correctly. The putstring functions for the BIOS is essential for future chapters because once we can print text, we can also print numbers after they are converted from text. This will be the subject of the next chapter.

## Real versus Protected Mode

There is a special process for switching to 32 or 64 bit protected modes. However these modes restrict you from accessing the hardware via the BIOS in the way I am teaching here.

For a look at programming in 32 or 64 bit Assembly programming, you might be interested in my Linux and Windows editions of Assembly Arithmetic Algorithms.

<https://leanpub.com/assemblyarithmeticalgorithms-Linux>

<https://leanpub.com/assemblyarithmeticalgorithms-windows>

# Chapter 2: Printing Integers

In the last chapter, I provided a version of the putstring function that works for the BIOS. If you happened to read the DOS edition of Assembly Arithmetic Algorithms, you might notice that it works very similar to the original function written for DOS. However, it writes characters one at a time until a zero byte is found.

But now that we have a way of printing strings, it is possible to print integers with a little bit of setup and writing some new functions.

The first, and most important of these new functions is intstr. It is identical to the function of the same name that was included in the DOS book. It takes the value of the ax register and converts it to a string. Then ax is loaded with the address of the newly created string.

It uses global variables to choose which radix will be used for displaying the number and also how many minimum digits (including leading zeros) are displayed. Each new function will go in its own file for organizational purposes.

## intstr.asm

```
; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 16 dup '?' ;reserve bytes for characters string for 16-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dw 2     ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dw 8 ;default width of integers. Extra zeros prefixed if more than 1

;this function creates a string of the integer in ax
;it uses the above radix variable to determine base from 2 to 36
;it then loads ax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov bx,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov cx,1

digits_start:

mov dx,0;
div word [radix]
cmp dx,10
jb decimal_digit
jnb hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add dx,'0'
jmp save_digit

hexadecimal_digit:
sub dx,10
add dx,'A'

save_digit:

mov [bx],dl
cmp ax,0
jz intstr_end
dec bx
inc cx
jmp digits_start

intstr_end:

prefix_zeros:
cmp cx,[int_width]
jnb end_zeros
dec bx
mov byte[bx], '0'
inc cx
jmp prefix_zeros
end_zeros:

mov ax,bx ; store string in ax for display later

ret
```

The next function is called putint, and all it does is back up registers to the stack, then it calls intstr and putstring, then restores the registers to what they were before putint was called.

This function was necessary because intstr destroys whatever the original value of ax was. Using the stack with the push and pop instructions is a common and convenient way of saving and loading registers or memory variables in Assembly language. The stack was fully covered in the DOS book, but you will see the same technique a lot in this book.

## putint.asm

```
;function to print string form of whatever integer is in ax
;The radix determines which number base the string form takes.
;Anything from 2 to 36 is a valid radix
;in practice though, only bases 2,8,10,and 16 will make sense to other programmers
;this function does not process anything by itself but calls the combination of my other
;functions in the order I intended them to be used.

putint: 

push ax
push bx
push cx
push dx

call intstr
call putstring

pop dx
pop cx
pop bx
pop ax

ret
```

There is only one more small function we need to display things right. We need a way to go the next line after printing a number. The sequence 0D 0A in hexadecimal is the newline sequence defined like this:

- 0D Carriage Return (move cursor to left of screen)
- 0A Line Feed (move cursor down to next line)

The BIOS uses this standard sequence for the interrupt used in the putstring function. Operating Systems like DOS and Windows also used these characters to define the end of a line.

The putline function is not hard to understand but the way I wrote it is important. Like putint, it preserves the ax register so that we can temporarily load the string containing only the newline sequence and then call putstring on it. Then ax will be popped back to what it was. Writing a new line is a common enough operation that it deserves its own function. Here it is:

## putline.asm

```
;the next function which pushes ax to the stack
;moves the address of the line string and prints it with putstring
;then it pops the original value of ax back from the stack before the function returns
;this allows me to print a newline anywhere in the code without a single register changing

line db 0Dh,0Ah,0 ;a string containing only a newline

putline:
push ax
mov ax,line
call putstring
pop ax
ret
```

Now that all the functions we need are written, they will all be included into our next full Assembly program for the BIOS. Here is the full program:

## main.asm

```
org 0x7C00

main:
mov ax,string0
call putstring
mov word[radix],16    ;choose radix for integer output!
mov word[int_width],4 ;minimum width of digits
mov ax,0
mov bx,0x18
loop0:
call putline
call putint
inc ax
cmp ax,bx
jnz loop0
jmp $

string0 db 'BIOS Assembly Counting Program',0
include 'putstring-bios.asm'
include 'intstr.asm'
include 'putint.asm'
include 'putline.asm'

db 510-($-$$) dup 0 ;same as -> times 510-($-$$) db 0
dw 0xAA55 ;mark disk as boot sector
```

The output will look like this:

```
BIOS Assembly Counting Program
0000
0001
0002
0003
0004
0005
0006
0007
0008
0009
000A
000B
000C
000D
000F
0010
0011
0012
0013
0014
0015
0016
0017
```

You may notice that I made the creative choice of printing the numbers in hexadecimal. This is because using base ten (decimal) is not very helpful because computers use binary. Each 4 digits of binary equals 1 digit of hexadecimal.

Hexadecimal is therefore just the most convenient base to print things in, but feel free to change this line:

```
mov word[radix],16
```

To a number other than 16. You can use any base from 2 to 36 because my intstr function is flexible enough to handle almost anything.

Now that we can print arbitrary strings of text and numbers in all kinds of radixes, the standard library of text output is complete. The next step is getting input from the keyboard. The next chapter will cover this task.
