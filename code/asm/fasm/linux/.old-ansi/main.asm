format ELF executable
entry main
start:


include 'chastelib32.asm'
include 'ansi.asm'

main: ; the main function of our assembly function, just as if I were writing C.

mov [radix],16 ; Choose radix for integer output!
mov [int_width],8
mov [int_newline],0 ;disable automatic printing of newlines after putint

mov [memory_address],start;main

keyloop:

;first clear the screen
mov eax, ansi_clear
call putstring

;reset cursor to home AKA top left of screen
mov eax,ansi_home
call putstring

mov eax,[key]
call putint
call putline

;print the memory at current address
call print_memory_row_hex



mov eax,msg
call putstring

call read_key

cmp [key],0x41
jz memory_prev_row
cmp [key],0x42
jz memory_next_row

cmp [key],0x44
jz memory_prev_byte
cmp [key],0x43
jz memory_next_byte

jmp keyloop_end

;conditional blocks based on input
memory_prev_row:
sub [memory_address],0x10
jmp keyloop_end
memory_next_row:
add [memory_address],0x10
jmp keyloop_end

memory_prev_byte:
sub [memory_address],1
jmp keyloop_end
memory_next_byte:
add [memory_address],1
jmp keyloop_end


keyloop_end:
cmp [key],'q' ;loop will go until q is pressed
jnz keyloop



mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

; this is where I keep my string variables

msg db 'Press q to quit, h for help', 0Ah,0     ; assign msg variable with your message string


memory_address dd 0

;this function prints a row of hex bytes
;each row is 16 bytes
print_memory_row_hex:
mov eax,[memory_address]
mov [int_width],8
call putint
call putspace

mov ebx,[memory_address]
mov ecx,0x10
next_byte:
mov eax,0
mov al,[ebx]
mov [int_width],2
call putint
call putspace

inc ebx
dec ecx
cmp ecx,0
jnz next_byte

call print_memory_row_text

call putline

ret

text_dump db 16 dup '?',0

print_memory_row_text:

mov ebx,[memory_address]
mov edi,text_dump
mov ecx,0x10
next_char:
mov eax,0
mov al,[ebx]
mov [int_width],2

;if char is below '0' or above '9', it is outside the range of these and is not a digit
cmp al,0x20
jb not_printable
cmp al,0x7E
ja not_printable

;if char is in printable range,copy as is and proceed to next index
jmp next_index

not_printable:
mov al,'.' ;otherwise replace with placeholder value

next_index:
mov [edi],al
inc edi
inc ebx
dec ecx
cmp ecx,0
jnz next_char


mov eax,text_dump
call putstring

ret