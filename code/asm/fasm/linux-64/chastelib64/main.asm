format ELF64 executable
entry main

include 'chastelib64.asm'

main: ; the main function of the assembly program

mov rax,main_string
call putstring

mov [radix],16           ; can choose radix for integer output!
mov [int_width],1

mov rax,input_string_int ;address of input string to convert to integer
call strint              ;call strint to return the string in eax register
mov rbx,rax              ;rbx=rax (copy the converted value returned in rax to rbx)

mov rax,0
loop1:

mov [radix],2            ;set radix to binary
mov [int_width],8        ;width of 8 bits
call putint
call putspace
mov [radix],16           ;set radix to hexadecimal
mov [int_width],2        ;width of 2 hex digits
call putint
call putspace
mov [radix],10           ;set radix to decimal (what humans read)
mov [int_width],3        ;width of 3 decimal digits
call putint

cmp al,0x20 ;check if al is in printable range
jb not_char ;if not then jump to not_char label
cmp al,0x7E
ja not_char

call putspace
call putchar             ;print the character if it is in the range 0x20 to 0x7E

not_char:                ;jump here if character is outside range to print

call putline             ;print newline before the next loop

inc rax
cmp rax,rbx;
jnz loop1

mov rax, 60 ; invoke SYS_EXIT (kernel opcode 60 on 64 bit systems)
mov rdi,0   ; return 0 status on exit - 'No Errors'
syscall

;A string to test if output works
main_string db 'This program is the official test suite for the Linux Assembly version of chastelib.',0Ah,0
;test string of integer for input
input_string_int db '100',0

; This Assembly source file has been formatted for the FASM assembler.
; The following 3 commands assemble, give executable permissions, and run the program
;
;	fasm main.asm
;	chmod +x main
;	./main
