format PE64 console
entry main

include 'win64ax.inc' ; Includes standard Windows 64-bit definitions and macros
include 'chastelib-w64.asm'

main:

sub rsp,40 ;align stack (required in windows 64-bit)

mov rax,main_string
call putstring

mov qword[radix],16       ;I can choose the radix for integer output!
mov qword[int_width],1    ;and the width of each integer for padded zeros

mov rax,input_string_int  ;address of input string to convert to integer
call strint               ;call strint to return the string in rax register
mov rbx,rax               ;rbx=rax (copy the converted value returned in rax to rbx)

mov rax,0
loop0:

mov qword[radix],2        ;set radix to binary
mov qword[int_width],8    ;width of 8 bits
call putint
call putspace
mov qword[radix],16       ;set radix to hexadecimal
mov qword[int_width],2    ;width of 2 hex digits
call putint
call putspace
mov qword[radix],10       ;set radix to decimal (what humans read)
mov qword[int_width],3    ;width of 3 decimal digits
call putint

cmp al,0x20               ;check if al is in printable range
jb not_char               ;if not then jump to not_char label
cmp al,0x7E
ja not_char

call putspace
call putchar              ;print the character if it is in the range 0x20 to 0x7E

not_char:                 ;jump here if character is outside range to print

call putline              ;print newline before the next loop

inc rax
cmp rax,rbx;
jnz loop0

mov rax,main_string
call putstring

;Exit the process with code 0
mov rcx,0
call [ExitProcess]

;A string to test if output works
main_string db 'test suite for 64 bit Windows Assembly version of chastelib.',0x0D,0x0A,0
;test string of integer for input
input_string_int db '100',0

;FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable
    library kernel32, 'KERNEL32.DLL'

    import kernel32,\
           GetStdHandle, 'GetStdHandle',\
           WriteFile, 'WriteFile',\
           ExitProcess, 'ExitProcess'
