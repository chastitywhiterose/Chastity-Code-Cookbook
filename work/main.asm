org 100h

main:

;set up the extra segment at the beginning of the program
;to point to the video memory segment in DOS text mode
mov ax, 0xB800
mov es, ax ; Or mov ds, ax


;80 columes times 25 rows is 2000 chars
;but since each character is two bytes
;4000 is the number of bytes to erase
;whatever character we write in this loop will fill the whole screen!

mov bx,0
screen_clear:
mov [es:bx],word 0x0403
add bx,2
cmp bx,4000
jnz screen_clear

mov ax,title  ;the string we intend to write to video RAM
mov ch,0x0F   ;the character attribute
mov dx,0x0218
call putstring_vram


;set the starting attribute for characters and location
mov ch,0x0F   ;the character attribute
mov dx,0x0501 ;x,y position of where text should start on screen

mov [line_start_x],dl ;save position of x position the line starts on

mov ah,0 ;used to keep track of rows
mov al,'0' ;actual character printed

loop_vram:
call putchar_vram
inc dl
inc ah
cmp ah,0x10
jnz skip_newline
add dh,1
mov dl,0
mov dl,[line_start_x] ;load position of x position the line starts on

mov ah,0
skip_newline:
inc al
cmp al,0
jnz loop_vram
loop_vram_end:

mov ax,4C00h
int 21h

title db 'Chastity Video RAM Demonstration!',0
;v_str db 'Hello World! This string will be written to video RAM using Assembly language!',0

;Unlike previous functions I wrote that use DOS interrupts to write text to the screen
;this one makes use of several registers which are not meant to be preserved
;registers ax,cx,and dx must be set before calling this function

;ax = address of string to write
;bx = copied from ax and used to index the string
;cx = used for character attribute(ch) and value(cl)
;dx = column(x pos) and row(y pos) of where string should be printed

;For this routine, I chose to copy the dx register to memory locations for clarity
;Yes, it wastes some bytes but at least I can read it as I am familiar with x,y coordinates
;Most importantly, the dx register is never modified in this function
;This is important because the main program may need to modify it in a loop
;For writing data in consecutive rows (e.g. integer sequences)

x db 0
y db 0

putstring_vram:

mov bx,ax             ;copy ax to bx for use as index register

;get x and y positions from each byte of dx register
mov [x],dl
mov [y],dh

mov ax,80  ;set ax to 80 because there are 80 chars per row in text mode
mul byte [y]    ;multiply with the y value
mov byte [y],0  ;zero the y byte so we can add a 16 bit x value to ax
add ax, word [x]

shl ax,1 ;shift left once to account for two bytes per character

mov di,ax ;we will use di as our starting output location

putstring_vram_strlen_start:    ;this loop finds the length of the string as part of the putstring function

cmp [bx],byte 0                 ;compare this byte with 0
jz putstring_vram_strlen_end    ;if comparison was zero, jump to loop end because we have found the length/end of string
mov cl,[bx]                     ;mov this character to cl
mov [es:di],cx                  ;mov character and attribute set in ch(before calling this function) to extra_segment+di
add di,2                        ;each character contains two bytes (ASCII+Attribute). We must add two here.
inc bx                          ;increment bx to point to next character
jmp putstring_vram_strlen_start ;jump to the start of the loop and keep trying until we find a zero

putstring_vram_strlen_end:

ret

line_start_x db 0;

;a function for putting a single character. I had a specific reason for this.
;the al register contains the character we want to print

putchar_vram:

;get x and y positions from each byte of dx register
mov [x],dl
mov [y],dh

push ax ;ax as a temp register for multiplication to calculate draw position

mov ax,80  ;set ax to 80 because there are 80 chars per row in text mode
mul byte [y]    ;multiply with the y value
mov byte [y],0  ;zero the y byte so we can add a 16 bit x value to ax
add ax, word [x]

shl ax,1 ;shift left once to account for two bytes per character

mov di,ax ;we will use di as our starting output location

pop ax ;we are done with using ax as a temp register for multiplication

putchar_vram_strlen_start:    ;this loop finds the length of the string as part of the putstring function

mov cl,al                     ;mov this character to cl
mov [es:di],cx                  ;mov character and attribute set in ch(before calling this function) to extra_segment+di
add di,2                        ;each character contains two bytes (ASCII+Attribute). We must add two here.
inc bx                          ;increment bx to point to next character

putchar_vram_strlen_end:

ret
