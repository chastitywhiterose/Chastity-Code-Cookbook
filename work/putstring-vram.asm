;The function below is putstring for the BIOS on Intel PCs
;The BIOS has a set of interrupts that work before any operating system has loaded
;However, this function still works under FreeDOS or DOSBox
;Because all BIOS functions are still available in real 16-bit mode

putstring_vram:

push ax
push bx
mov bx,ax              ;copy ax to bx to be used as index to the string
mov ah,0xE             ;Select Function 0xE for interrupt 0x10
putstring_vram_beg:    ;this loop finds the length of the string as part of the putstring function
cmp byte[bx],0         ;compare this byte with 0
jz putstring_vram_end  ;if comparison was zero, jump to loop end because we have found the length
mov al,[bx]            ;load al register with this character
;int 0x10              ;call the BIOS to print this character
call putchar_vram      ;call my function to print this character
inc bx
jmp putstring_vram_beg ;jump to the start of the loop and keep trying until we find a zero
putstring_vram_end:
pop bx
pop ax

ret

;variables for managing text in Video RAM

tx dw 0 ;x location
ty dw 0 ;y location

char db 0
char_color db 0x0F

putchar_vram:

mov [char],al ;copy character from al to temp place
;save all registers used
push ax
push bx
push di

;set the extra segment to video memory
mov ax,0xB800
mov es,ax

mov ax,80     ;set ax to 80 because there are 80 chars per row in text mode
mul byte [ty]    ;multiply with the y value (vertical)
add ax, word [tx] ;add the x value (horizontal)

shl ax,1 ;shift left once to account for two bytes per character
mov di,ax ;we will use di as our starting output location

mov al,[char] ;load the character back to al
mov ah,[char_color] ;load the color attribute
mov [es:di],ax

inc word[tx] ;increment text x position
cmp word[tx],80 ;is x 80?
jnz same_line ;if not, stay on same line

next_line: ;otherwise, set to next line
mov word[tx],0
inc word[ty]

same_line:

;load all registers used
pop di
pop bx
pop ax

ret