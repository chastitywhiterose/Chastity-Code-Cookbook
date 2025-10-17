org 100h       ;tell assembler that code begins running at this address

mov ah,2       ; move (copy) the number 2 into the ah register
mov dl,20h     ; move the number 20 hex=32 dec into the dl register
loop_start:    ; the loop starts here
int 21h        ; interrupt 21 hex=33 dec for a DOS system call
inc dl         ; add 1 to the dl register
cmp dl,7Fh     ; compare the dl register with 7F hex = 127 dec
jne loop_start ; Jump if Not Equal to loop_start

mov ax,4C00h   ; DOS exit call with ah=4C and return al=0
int 21h        ; DOS system call to complete the exit function
