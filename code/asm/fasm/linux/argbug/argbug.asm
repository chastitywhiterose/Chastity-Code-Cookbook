there is an error in here but I don't know where

;variables for putarg
argc dd 0
argx dd 0

argc_string db 'argc=',0
argx_string db 'argx=',0

stkval dd 0 ; to save the place to return to from the putarg function

;a function to print all the command line arguments for debugging purposes

putarg:
pop [stkval]

mov eax,argc_string
call putstring

pop eax
call putint

mov [argc],eax ;save the argument count for later

;mov eax,test_input_string
;call strint

mov [argx],0

next_arg:
mov eax,argx_string
call putstring
mov eax,[argx]
call putint
inc [argx]
pop eax
call putstring
mov eax,int_string_end
call putstring
dec [argc]
cmp [argc],0
jnz next_arg

push [stkval]
ret