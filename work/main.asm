org 100h

main:

;set up the extra segment at the beginning of the program
;to point to the video memory segment in DOS text mode
mov ax, 0xB800
mov es, ax ; Or mov ds, ax

mov dx,0x0406

mov ax,v_str
call putstring_vram


mov ax,4C00h
int 21h

v_str db 'This string will be written to video RAM!',0


include 'chastelib16.asm'

;Unlike previous functions I wrote that use DOS interrupts to write text to the screen
;this one makes use of several registers which are not meant to be preserved

;ax = address of string to write
;bx = copied from ax and used to index the string
;cx = used for character attribute(ch) and value(cl)
;dx = column and row of where string should be printed

x db 0
y db 0

putstring_vram:

mov bx,ax             ;copy ax to bx for use as index register

;get x and y positions from each byte of dx register
mov [x],dl
mov [y],dh

mov ax,0  ;first zero ax to avoid any confusion
mov ah,[y] ;load y position
mul byte 25 


mov dl,0

mov di,dx ;we will use di as our starting output location

;cx register will be our character and attribute
mov ch,0x0F ;set ch (upper half of cx) to the color we want characters to be


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


