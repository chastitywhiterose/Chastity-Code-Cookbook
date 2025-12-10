org 100h

main:

;set up the extra segment at the beginning of the program
;to point to the video memory segment in DOS text mode
mov ax, 0xB800
mov es, ax ; Or mov ds, ax

; Example: Write 'A' with default attributes (light grey on black)
 mov al, 'A'       ; ASCII code for 'A'
 mov ah, 0x07      ; Attribute byte (light grey on black)
 mov [es:0], ax ; Write both bytes to video memory

mov ax,v_str
call putstring_vram





mov ax,main_string
call putstring

mov word [radix],2 ; can choose radix for integer output!
mov word [int_width],8

mov ax,test_int
call strint

mov word [radix],16 ; can choose radix for integer output!

call putint


mov ax,4C00h
int 21h

v_str db 'This string will be written to video',10,'  RAM!',0

main_string db "This is Chastity's 16-bit Assembly Language counting program!",0Dh,0Ah,0

; test string of integer for input
test_int db '11111000011',0

include 'chastelib16.asm'

;Unlike previous functions I wrote that use DOS interrupts to write text to the screen
;this one makes use of several registers which are not meant to be preserved

;ax = address of string to write
;bx = copied from ax and used to index the string
;cx = used for character attribute(ch) and value(cl)

putstring_vram:

mov di,0 ;we will use di as our starting output location

;cx register will be our character and attribute
mov ch,7 ;set ch (upper half of cx) to the color we want characters to be

mov bx,ax                  ;copy ax to bx for use as index register

putstring_vram_strlen_start:    ;this loop finds the length of the string as part of the putstring function

cmp [bx], byte 0           ;compare this byte with 0
jz putstring_vram_strlen_end    ;if comparison was zero, jump to loop end because we have found the length/end of string
mov cl,[bx]                ;mov this character to cl
mov [es:di],cx
add di,2
inc bx                     ;increment bx (add 1)
jmp putstring_vram_strlen_start ;jump to the start of the loop and keep trying until we find a zero

putstring_vram_strlen_end:

ret


