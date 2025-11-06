# Chastity Windows API Reference

This file has links where I can read about the Windows API calls that I need for my programs. There is a lot I don't understand but I can still do basic tasks.

<https://learn.microsoft.com/en-us/windows/console/getstdhandle>  
<https://learn.microsoft.com/en-us/windows/console/writeconsole>  
<https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile>  
<https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getcommandlinea>  

# Examples

I will show you an example program which writes text to the console and then exits.

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

This program arguably works because it displays the text to the console Window. One thing I noticed however is that I cannot redirect the standard output to a file such as `main > out.txt`.

To solve this, here is a modified program which uses the WriteFile system call instead. It requires one more argument to be passed when it is called but the value will be ignored if it is zero. More importantly, if you redirect the program output to a file, it will actually be sent to that file. This makes the WriteFile call better than WriteConsole in all cases.

```
format PE console
include 'win32ax.inc'

main:

;Write 13 bytes from a string to standard output
push 0              ;Optional Overlapped Structure 
push 0              ;Optionally Store Number of Bytes Written
push 13             ;Number of bytes to write
push main_string    ;address of string to print
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [WriteFile]    ;all the data is in place, do the write thing!

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

main_string db 'Hello World!',0Ah
```
