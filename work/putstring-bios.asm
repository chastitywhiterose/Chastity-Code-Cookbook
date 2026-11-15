;The function below is putstring for the BIOS on Intel PCs
;The BIOS has a set of interrupts that work before any operating system has loaded
;However, this function still works under FreeDOS or DOSBox
;Because all BIOS functions are still available in real 16-bit mode

putstring:

push ax
push bx
mov bx,ax              ;bx will be used as index to the string
mov ah,0xE             ;Select Function 0xE for interrupt 0x10
putstring_bios_beg:    ;putstring loop beginning
cmp byte[bx],0         ;compare this byte with 0
jz putstring_bios_end  ;if comparison was zero,end the loop
mov al,[bx]            ;load al register with this character
int 0x10               ;call the BIOS to print this character
inc bx
jmp putstring_bios_beg ;restart loop until we find a zero
putstring_bios_end:    ;putstring loop end
pop bx
pop ax

ret