;a function to return zero in the ax register if no arguments are available
;if arguments are available, return a pointer in ax to the first argument

getarg:

mov bx,[arguments_start] ;get the address of start of arguments
cmp bx,0 ;is this address zero? (meaning this function was not called before)
jz get_arg_data ;if it was zero, then get the argument data for the first execution of this function
;cmp bx,[arguments_end]   ;is the address of the start and end the same?


;this will happen first time this function is called to get the argument data
get_arg_data:
mov ax,0
;mov ah,0     ;zero ah (upper half of ax)
mov al,[80h] ;load length of the command string from this address
cmp ax,0
jz getarg_end

mov bx,0x81  ;mov into bx the address of the start of the argument string
mov [arguments_start],bx ;save the start of the arguments to this variable
add bx,ax    ;add the length of the command string to this address
mov byte[bx],0 ;terminate this with a zero to avoid segfaults when printed with putsting
mov [arguments_end],bx ;save the end of the arguments to this variable
mov ax,[arguments_start] ;copy the address of the arguments start to ax

getarg_end:
ret

arguments_start dw 0
arguments_end dw 0

arguments_index dw 0
