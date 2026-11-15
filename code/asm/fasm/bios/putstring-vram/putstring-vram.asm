;The function below is putstring for the BIOS on Intel PCs
;The BIOS has a set of interrupts that work before any operating system has loaded
;However, this function still works under FreeDOS or DOSBox
;Because all BIOS functions are still available in real 16-bit mode

putstring_vram:

push ax
push bx
mov bx,ax              ;bx will be used as index to the string

putstring_vram_beg:    ;putstring loop beginning
cmp byte[bx],0         ;compare this byte with 0
jz putstring_vram_end  ;if comparison was zero,end the loop
mov al,[bx]            ;load al register with this character
call putchar_vram      ;call function to print this character
inc bx
jmp putstring_vram_beg ;restart loop until we find a zero
putstring_vram_end:    ;putstring loop end
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
push di

;special case for newline sequence of hex 0D 0A
;if these two bytes are at this location in the string
;increment bx in this function because it will also
;be incremented in the putstring_vram function
;this ensures whatever is after the two bytes of
;carriage return 0D and line feed 0A is printed next

mov ax,[bx]          ;load the two bytes indexed by bx
cmp ax,0x0A0D        ;is this a newline sequence?
jnz putchar_vram_beg ;if not, proceed to print as normal
inc bx               ;skip past this two byte sequence
jmp next_line

putchar_vram_beg:
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
pop ax

ret