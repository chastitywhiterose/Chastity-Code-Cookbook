# Chastity Windows Reverse Engineering Notes

The Windows version of FASM includes header files for the Windows API. It also includes some examples, but not a single one of them were a simple "Hello World" console program.

Fortunately, I was able to find one that actually assembled and ran on the FASM forum. Below is the source code.

```
format PE console
include 'win32ax.inc'
.code
start:
invoke  WriteConsole, <invoke GetStdHandle,STD_OUTPUT_HANDLE>,"Hello World!",12,0
invoke  ExitProcess,0
.end start
```

To get it working required me to keep the include files in a location I remembered and set the include environment variable. I found this out from the FASM Windows documentation.

set include=C:\fasm\INCLUDE

However, there was another problem. The example that I found online and got working uses macros, most specifically, one called "invoke". While this works if you include the headers, it hides the details of what is actually happening. Therefore, I decided to reverse engineer the process by using NOP instructions to sandwich the bytes of machine code.

90 hex is the byte for NOP (No OPeration). So to extract the macro call that exits the program, I use this.

```
db 10h dup 90h
invoke  ExitProcess,0
db 10h dup 90h
```

Then I disassemble the executable and find the actual instructions given.

`ndisasm main.exe -b 32 > disasm.txt`

As simple as this method is, it actually works. For example, this output is given as part of the output.

```
0000022D  90                nop
0000022E  90                nop
0000022F  90                nop
00000230  90                nop
00000231  90                nop
00000232  90                nop
00000233  90                nop
00000234  90                nop
00000235  90                nop
00000236  90                nop
00000237  90                nop
00000238  90                nop
00000239  90                nop
0000023A  90                nop
0000023B  90                nop
0000023C  90                nop
0000023D  6A00              push dword 0x0
0000023F  FF1548204000      call dword near [0x402048]
00000245  90                nop
00000246  90                nop
00000247  90                nop
00000248  90                nop
00000249  90                nop
0000024A  90                nop
0000024B  90                nop
0000024C  90                nop
0000024D  90                nop
0000024E  90                nop
0000024F  90                nop
00000250  90                nop
00000251  90                nop
00000252  90                nop
00000253  90                nop
00000254  90                nop
```

There can be no mistake that it is that location between the NOPs where the relevant code is. Therefore, I replaced the macro that exits the program with this.

```
;Exit the process with code 0
 push 0
 call [ExitProcess]
```

## What I learned

As I repeated the same process for the other macros, I found that the way system calls in Windows work is that the numbers are pushed onto the stack in the reverse order they are needed. I was able to decode the macros and get a working program without the use of "invoke". Here is the full source!

```
format PE console
include 'win32ax.inc'

main:

;Write 13 bytes from a string to standard output
push 0              ;this must be zero. I have no idea why!  
push 13             ;number of bytes to write
push main_string    ;address of string to print
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [WriteConsole] ;all the data is in place, do the write thing!

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

main_string db 'Hello World!',0Ah
```

I don't know much about the Windows API, but I did discover some helpful information when I searched the names of these functions that were part of the original macros. Below are some links to Microsoft documentation about these functions.

<https://learn.microsoft.com/en-us/windows/console/getstdhandle>  
<https://learn.microsoft.com/en-us/windows/console/writeconsole>  
<https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile>

## Why I did this

You might wonder why I even bothered to get a working Windows API program in Assembly Language. After all, I am a Linux user to the extreme. However, since Windows is the most used operating system for the average person, I figured that if I write any useful programs in Assembly for 32-bit Linux, I can probably port them over to Windows by changing just a few things.

Since my toy programs are designed to write text to the console anyway and I don't do GUI stuff unless I am programming a game in C with SDL, I now have enough information from this small Hello World example to theoretically write anything to the console that I might want to in an official Windows executable.

Obviously I need to learn a lot more for bigger programs but this is the first Assembly program I have ever gotten working for Windows, despite my great success with DOS and Linux, which are easier because they are better documented and **ARE TAUGHT BETTER** by others. People programming Assembly in Windows have been ruined by macros which hide the actual instructions being used. As I learn how these things work, I will be sure to pass on the information to others!
