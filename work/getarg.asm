;a function to return zero in the ax register if no arguments are available
;if arguments are available, return a pointer in ax to the first argument

getarg:

mov ax,0
;mov ah,0     ;zero ah (upper half of ax)
mov al,[80h] ;load length of the command string from this address
cmp ax,0
jz getarg_end

mov bx,0x81  ;mov into bx the start of the argument string
add bx,ax  

getarg_end:
ret