global  _start

_start:

mov eax,main_string
call putstring

mov dword[radix],16           ; can choose radix for integer output!
mov dword[int_width],1

mov eax,input_string_int ;address of input string to convert to integer
call strint              ;call strint to return the string in eax register
mov ebx,eax              ;ebx=eax (copy the converted value returned in eax to ebx)

mov eax,0
loop1:

mov dword[radix],2            ;set radix to binary
mov dword[int_width],8        ;width of 8 bits
call putint
call putspace
mov dword[radix],16           ;set radix to hexadecimal
mov dword[int_width],2        ;width of 2 hex digits
call putint
call putspace
mov dword[radix],10           ;set radix to decimal (what humans read)
mov dword[int_width],3        ;width of 3 decimal digits
call putint

cmp al,0x20 ;check if al is in printable range
jb not_char ;if not then jump to not_char label
cmp al,0x7E
ja not_char

call putspace
call putchar             ;print the character if it is in the range 0x20 to 0x7E

not_char:                ;jump here if character is outside range to print

call putline             ;print newline before the next loop

inc eax
cmp eax,ebx;
jnz loop1

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

;A string to test if output works
main_string db 'This program is the official test suite for the Linux Assembly version of chastelib.',0Ah,0
;test string of integer for input
input_string_int db '100',0

;we must declare a data section for the header because it contains writable data
;unlike FASM, NASM and the Gnu Assembler and linker are strict about sections
section .data

%include 'chastelib32.asm' ;include chastelib core functions header

; This Assembly source file has been formatted for the NASM assembler.
; The following 3 commands assemble, link, and run the program
;
;	nasm -f elf main.asm
;	ld -s -m elf_i386 main.o -o main
;	./main
