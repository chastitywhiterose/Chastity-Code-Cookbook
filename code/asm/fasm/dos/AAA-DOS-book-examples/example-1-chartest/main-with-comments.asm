org 100h          ;tell assembler that code begins running at this address

mov ah,2          ; move (copy) the number 2 into the ah register
mov dl,20h        ; move the number 20 hex = 32 dec into the dl register
start_of_loop:    ; a label that we will be jumping back to as the start of a loop
int 21h           ; interrupt 21 hex = 33 dec starts a DOS system call
add dl,1          ; add 1 to the dl register
cmp dl,7Fh        ; compare the dl register with 7F hex = 127 dec
jne start_of_loop ; Jump if Not Equal at the comparison above to restart the loop

mov ah,0          ; move zero into the ah register for the program exit call
int 21h           ; DOS system call again but with a different ah value than before.
