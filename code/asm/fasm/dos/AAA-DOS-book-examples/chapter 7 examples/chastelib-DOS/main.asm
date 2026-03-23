org 100h

main:

mov eax,main_string
call putstring

mov word[radix],16           ; can choose radix for integer output!
mov word[int_width],1
mov byte[int_newline],0

mov ax,input_string_int  ;address of input string to convert to integer using current radix
call strint              ;call strint to return the string in eax register
mov bx,ax                ;bx=ax (copy the converted value returned in ax to bx)

mov ax,0
loop1:

mov word[radix],2            ;set radix to binary
mov word[int_width],8        ;width of 8 bits
call putint
call putspace
mov word[radix],16           ;set radix to hexadecimal
mov word[int_width],2        ;width of 2 hex digits
call putint
call putspace
mov word[radix],10           ;set radix to decimal (what humans read)
mov word[int_width],3        ;width of 3 decimal digits
call putint

cmp al,0x20 ;check if al is in printable range
jb not_char ;if not then jump to not_char label
cmp al,0x7E 
ja not_char

call putspace
call putchar ;print the character if it is in the range 0x20 to 0x7E

not_char:    ;jump here if character is outside range to print

call putline ;print newline before the next loop

inc ax
cmp ax,bx;
jnz loop1

mov ax,4C00h ;DOS system call number ah=0x4C to exit program with ah=0x00 as return value
int 21h      ;DOS interrupt to exit the program with numbers on previous line

;A string to test if output works
main_string db 'Official test suite for the DOS Assembly version of chastelib.',0Ah,0

;test string of integer for input
input_string_int db '100',0

include 'chastelib16.asm' ; use %include if assembling with NASM instead of FASM.

; This 16 bit DOS Assembly source has been formatted for the FASM assembler.
; In order to run it, you will need the DOSBOX emulator or something similar.
; First, assemble it into a binary file. FASM will automatically add
; the .com extension because of the "org 100h" command.
;
;	fasm main.asm
;
; Then you will need to open DOSBOX and mount the folder that it is in.
; For example:
;
;	mount c ~/.dos
;	c:
;
;	Then, you will be able to just run the main.com.
;
;	main
