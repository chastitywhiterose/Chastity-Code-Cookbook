;The function below is putstring for the BIOS on Intel PCs
;The BIOS has a set of interrupts that work before any operating system has loaded
;However, this function still works under FreeDOS or DOSBox
;Because all BIOS functions are still available in real 16-bit mode

putstring:

push ax
push bx
mov bx,ax                  ;copy ax to bx to be used as index to the string
mov ah,0xE                 ;Select Function 0xE for interrupt 0x10
putstring_strlen_start:    ;this loop finds the length of the string as part of the putstring function
cmp byte[bx],0             ;compare this byte with 0
jz putstring_strlen_end    ;if comparison was zero, jump to loop end because we have found the length
mov al,[bx]                ;load al register with this character
int 0x10                   ;call the BIOS to print this character
inc bx
jmp putstring_strlen_start ;jump to the start of the loop and keep trying until we find a zero
putstring_strlen_end:
pop bx
pop ax

ret