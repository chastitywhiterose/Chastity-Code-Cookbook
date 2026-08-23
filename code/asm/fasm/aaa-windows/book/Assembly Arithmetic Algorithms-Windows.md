# Assembly Arithmetic Algorithms

32 and 64 bit Windows Edition

# Preface

This book is the Windows edition of Assembly Arithmetic Algorithms. The first book was for 16-bit DOS programming using Assembly. The second book was for 32-bit Linux programming using the same assembly language for Intel machines. But this book is very different than those because it is for Windows users who don't know anything about DOS or Linux.

I suspect most people fall into this category because Windows comes preinstalled on almost any PC you would buy in a store. Although I am old enough to have experienced DOS, and autistic enough use Linux for everything since my teenage days, I am aware that most people will never both trying other operating systems.

Although I use Linux for most things, I had to buy a laptop with Windows on it to use specific software required by Full Sail University when I was an online student. Since I have it, I decided I might as well try out some assembly language on it and learn how it works so I can pass the knowledge on to other peeople who are not ready to leave Windows but ARE ready to try learning assembly language.

At the time of this writing, most Windows systems use the x86-64 Intel architecture which can run 32-bit or 64-bit code. Because of this, I have decided to include code samples for both modes and explain the differences between them.

I highly suspect people don't even know what it means for something to be 32 or 64 bits. Understanding this requires knowing that a bit is a **BI**nary digi**T** and explaining the binary numeral system.

If you are someone who likes to learn the math behind how computers work, but still cannot or don't want to switch to Linux, this book will act as a bridge to test the waters of Assembly language and the control it offers you as a programmer. Programming in Assembly language is not a task for complete computer programming beginners. I do recommend having some C or C++ experience before jumping into this book, but I have tried my best not to assume knowledge of any prior languages when writing my explanations.


# Introduction

In this short book, I plan to teach you the basics of Assembly language for Intel Central Processing Units and you will learn how to make small programs that run on the Windows operating system. Theoretically, these programs should be compatible with Windows version 7, 8, 10, and 11. My only OS to test with is Windows 11 which is on the laptop I am writing this on.

There is one myth that I need to break before I can teach you how to get started programming on Windows. This book will not use an IDE (Interactive Development Environment). I consider IDEs to be evil because they hide the details of how things work. You WILL be entering commands at a terminal which is called the "Command Prompt" or the executable file at:

```
"C:\WINDOWS\system32\cmd.exe"
```

This program is the modern descendant of the original command.com from DOS. Windows may no longer be compatible with DOS but MS-DOS was a Microsoft product and Windows originally started as a program that can in DOS. Therefore, common commands such as "dir", "mkdir, "copy", "del", "rename", "type" and "exit" still work the same as they did on DOS.

Because the Assembler I will be using is FASM, which includes an IDE, you don't technically have to use the command line the way I will teach you, but you are cheating yourself if you don't become comfortable with basic commands in a terminal/console.

There is a common lie that Windows is point and click whereas Linux requires running commands at a terminal. Technically neither of these are true. The actualy truth is that a PROGRAMMER must know how to use the command line on ANY operating system to achieve full power in controlling their own operating system or the building of their own programs.

But don't worry, you don't need to have been born in 1987 or grow up reading MS-DOS manuals to learn these commands. I will give you all the commands you need and you will still be pointing and clicking your way through the Windows file explorer a lot when going to your specific folder or directory (these two words mean the exact same thing in this context).

The best part is that you can use any text editor you like. However, I recommend either the default Notepad so you don't have to install an extra tool, or perhaps installing Notepad++ to benefit from syntax highlighting.

# Chapter 1: The First Program

Before you can write Windows programs in Assembly language, you will need the FASM Assembler. Be sure to download the Windows version from here:

<https://flatassembler.net/>

The file will probably be named something similar to "fasmw17335.zip"

You will need to extract the files in the zip archive and place them somewhere convenient for you. I placed them in my root C drive directory.

```
C:\fasm
```

Here is an easy way to test and see if the files are correctly located.

Using the command "dir c:\fasm" should return the results of the following files:

```
 Volume in drive C is Windows-SSD
 Volume Serial Number is D43F-B788

 Directory of c:\fasm

08/20/2026  04:00 AM    <DIR>          .
08/20/2026  04:00 AM    <DIR>          EXAMPLES
08/20/2026  04:00 AM           118,272 FASM.EXE
08/20/2026  04:00 AM           529,038 FASM.PDF
08/20/2026  04:00 AM           161,280 FASMW.EXE
08/20/2026  04:00 AM    <DIR>          INCLUDE
08/20/2026  04:00 AM             1,820 LICENSE.TXT
08/20/2026  04:00 AM    <DIR>          SOURCE
08/20/2026  04:00 AM    <DIR>          TOOLS
08/20/2026  04:00 AM            17,640 WHATSNEW.TXT
               5 File(s)        828,050 bytes
               5 Dir(s)   5,106,724,864 bytes free
```

For this book, we will mostly be concerned with FASM.EXE and the INCLUDE directory. I also recommend reading the FASM.PDF file because it is where I learned how to use the FASM Assembler.

The next step is to (temporarily) set your path variables so that you can assemble your source files no matter which folder/directory you happen to be in. Once you have chosen you location to begin coding, you will want to run two commands to set the "path" and "include" variables. I usually place them in a short batch file named fasmpath.bat for convenience.

## fasmpath.bat

```
set path=C:\fasm
set include=C:\fasm\INCLUDE
```

Whether you type those two commands or just place them in a batch file and enter "fasmpath" to execute the script, either way, your paths will be set until you close your console/terminal window. Then all changes will revert to whatever your system defaults were.

There is a GUI setting to permanently change the variables but I DO NOT recommend this because making a mistake can make your system completely unusable. I will explain more about this later.

Anyway, once you have a source file of a valid program, you can assemble it like this.

```
fasm main.asm
```

The file does not have to specifically be named "main.asm". It could just as well be "fartbutt.asm" or even "count-dracula.txt". You can choose whatever seems like a good name to you and adjust the commands accordingly.

To get started, I will provide the first example program that can be assembled and run under the Windows operating system. This was tested on my laptop with Windows 11 but should theoretically work on older versions as well as long as you followed my instructions so far.

Behold,the "Hello World" source file for a Windows console program.

## Hello World for 32-bit Windows

```
format PE console
entry main

include 'win32ax.inc'       ;includes standard Windows 32-bit definitions and macros

main:

mov eax,main_string
call putstring


push 0             ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

;A string to test if output works
main_string db 'Hello World',0x0D,0x0A,0

write_count dd 0        ;variable to store how many bytes were written

putstring:              ;print string pointed to by eax register

push eax
push ebx
push ecx
push edx

mov ebx,eax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Write string using Win32 WriteFile system call.
push 0              ;Optional Overlapped Structure
push write_count    ;address to store how many bytes are written
push ebx            ;Number of bytes to write
push eax            ;address of string to print
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [WriteFile]    ;all the data is in place, do the write thing!

pop edx
pop ecx
pop ebx
pop eax

ret ;this is the end of the putstring function return to calling location

;FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
```

You might wonder why it took nearly 70 lines to print a simple message. That is because unlike in C, Pascal, or BASIC, there are no printf, write, or print statements. The included putstring function is one I had to write and is not normally available unless someone like me builds it.

It does however make use of the WriteFile Windows API call. My function calculates the length of the string by finding where the zero is and then subtracting the address of the beginning from the end. Then once the length is known, the arguments to the function are pushed to the stack in the order that Microsoft wanted them to be before calling the WriteFile function.

I have no idea where the source code for this API call is because it is proprietary information and Windows is not an Open Source operating system. However, using a Windows API call like this is an extremely fast operation and it is the start of everything else this book will cover.

However, this is only the 32 bit version of the program. A 64 bit version looks more like the following.

## Hello World for 64-bit Windows

```
format PE64 console
entry main

include 'win64ax.inc'       ;includes standard Windows 64-bit definitions and macros

main:

mov rax,main_string
call putstring

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

;A string to test if output works
main_string db 'Hello World',0x0D,0x0A,0

write_count dq 0        ;variable to store how many bytes were written

putstring:              ;print string pointed to by rax register

push rax
push rbx
push rcx
push rdx

mov rbx,rax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [rbx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp putstring_strlen_start

putstring_strlen_end:
sub rbx,rax ;subtract start pointer from current pointer to get length of string

sub rsp,40  ;align stack before Win API functions(required in windows 64-bit)

mov rdx,rax ;pointer to message

mov rcx, -11        ; STD_OUTPUT_HANDLE
call [GetStdHandle] ; Get Standard Output Handle
mov rcx,rax         ; copy handle to ecx

mov r8,rbx          ;message length
mov r9,write_count  ;address to store how many bytes are written

mov qword [rsp + 32], 0 ; Parameter 5: Must be placed on the stack
call [WriteFile]

add rsp,40  ;restore stack now that WinAPI calls are done

pop rdx
pop rcx
pop rbx
pop rax

ret ;this is the end of the putstring function return to calling location

;FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
```

Because in both cases, the programs are identical, you might wonder which is better or the correct thing to use. Actually, they are exactly the same but using a different calling convention.

You may also notice that at the bottom of the source files there is an "idata" section which includes data from the Windows kernel which is KERNEL32.DLL. Regardless of whether your code using 32 or 64 bit registers, the exact same functions from the kernel are being dynamically linked and loaded so that your program can do basic tasks.

## First 3 Windows API calls

These three functions are required for even a simple Hello World program like both of those above.

- GetStdHandle
- WriteFile
- ExitProcess

The documentation for these functions can be found on Microsoft's website but it is not very helpful because it is written for C and C++ programming.

<https://learn.microsoft.com/en-us/windows/console/getstdhandle>

<https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile>

<https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-exitprocess>

Despite the fact that most of the web pages don't tell us what we need for assembly, some of it is helpful. For example the following table for the 3 standard handles on the GetStdHandle page is copied below.

## GetStdHandle function table

|Value|Meaning|
|-----|-------|
|-10|STD_INPUT_HANDLE|
|-11|STD_OUTPUT_HANDLE|
|-12|STD_ERROR_HANDLE|

Because negative 11 is how the standard output handle is obtained, that is why the 32 bit putstring has these 3 lines

```
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
```

and the 64 bit putstring has these lines

```
mov rcx, -11        ; STD_OUTPUT_HANDLE
call [GetStdHandle] ; Get Standard Output Handle
mov rcx,rax         ; copy handle to ecx
```

In both cases, the argument -11 is passed to the GetStdHandle function. In 32 bit mode, it is pushed to the stack before the call and in 64 bit mode is is loaded into the rcx register before the call.

This may seem silly but it highlights the importance of a calling convention. If you read my DOS or Linux editions of Assembly Arithmetic Algorithms, you will see that they use a purely register based convention for all system calls.

Windows is harder because it uses a hybrid approach of sometimes using registers for function arguments and other times using specific locations on the stack relative to the stack pointer.

But you are probably asking at this point: "What is a stack?", "What is a register?", and "What is a bit?".

I will attempt to answer all these questions but it will take time. But before I end this chapter, I will give brief definitions.

## Register

A variable with a fixed name that is always available to use. These come in different sizes such as "EAX" for 32-bit and "RAX" for 64-bit.

## Bit

A bit is a BInary digiT. It is a number that can be 0 or 1. These are the only two numbers a bit can be but by combining multiple bits as a group, any number can be represented. Just as the decimal systems humans use only uses digits 0,1,2,3,4,5,6,7,8,9 but can represent any possible number, binary can also represent any number once you learn how it works. Explaining the Binary Numeral System will be a central feature of this book because no programmer can be successful without it.

## Stack

A stack can be many things. It can be a stack of plates, a stack of pancakes on top of plates that you are going to eat, or it can be a stack of numbers where we temporarily place numbers that are in registers and free them up to be used for other tasks. Assembly programming requires basic understanding of the stack, but Windows specifically requires using the stack in the way Microsoft wants you do. Admittedly this is less fun and restrictive but there are clever ways to break the convention.

This is the point where most people will give up. There are so many terms to learn and it takes a lot of information to even get a small program working to display a message like "Hello World".

But despite being difficult to get started, it gets easier as you proceed. It is like playing a new game which you don't know the controls for or where your character is supposed to go next. Yes Assembly is hard, but not as hard as playing the Legend of Zelda: Ocarina of Time. Seriously, that game way more stressful than any programming language I have have used (except for Rust).

A funny example I suppose, but programming really is like playing a game where you get to create your own rules. Perhaps Minecraft would be an even better example because you start with nothing and slowly create your own tools to progress faster.


To be continued