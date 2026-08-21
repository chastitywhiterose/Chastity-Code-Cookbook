format PE console
entry main

include 'win32ax.inc'
include 'chastelib-w32.asm'

main:



mov eax,main_string
call putstring

mov dword[radix],16       ;I can choose the radix for integer output!
mov dword[int_width],1    ;and the width of each integer for padded zeros

mov eax,input_string_int  ;address of input string to convert to integer
call strint               ;call strint to return the string in eax register
mov ebx,eax               ;ebx=eax (copy the converted value returned in eax to ebx)

mov eax,0
loop0:

mov dword[radix],2        ;set radix to binary
mov dword[int_width],8    ;width of 8 bits
call putint
call putspace
mov dword[radix],16       ;set radix to hexadecimal
mov dword[int_width],2    ;width of 2 hex digits
call putint
call putspace
mov dword[radix],10       ;set radix to decimal (what humans read)
mov dword[int_width],3    ;width of 3 decimal digits
call putint

cmp al,0x20
jb not_char
cmp al,0x7E
ja not_char

call putspace
call putchar

not_char:                 ;jump here if character is outside range to print

call putline              ;print newline before the next loop

inc eax
cmp eax,ebx;
jnz loop0

mov eax,main_string
call putstring

;Exit the process with code 0
push 0
call [ExitProcess]

;A string to test if output works
main_string db 'test suite for 32 bit Windows Assembly version of chastelib.',0x0D,0x0A,0
;test string of integer for input
input_string_int db '100',0

;FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable
    library kernel32, 'KERNEL32.DLL'

    import kernel32,\
           GetStdHandle, 'GetStdHandle',\
           WriteFile, 'WriteFile',\
           ExitProcess, 'ExitProcess'
