
; function to print zero terminated string pointed to by register eax
; this is implemented by repeatedly calling function 2 of the DOS interrupt 21h
; this function is very simple to write but it is also slower than one with a better system call

putstring_function_2h: 

mov bx,ax ; copy ax to cx as well. Now both registers have the address of the main_string

putstring_2h_strlen_start: ; this loop finds the lenge of the string as part of the putstring function

mov dl,[bx]
cmp dl,0 ; compare this byte byte at address with 0
jz strlen_2h_end ; if comparison was zero, jump to loop end because we have found the length

; call interrupt for printing a single character in dl register
mov ah,2
int 21h

inc bx
jmp putstring_2h_strlen_start

strlen_2h_end:

ret ; this is the end of the putstring function return to calling location







;print $ terminated string at address ax
;this function only works if there is a $ at the end of what you wish to print

putstring_function_9h:

mov dx,ax ; give dx register address of the string

;do the Hello World with function 9 (the easy way)
mov ah,9h  ; call function 9 (write string terminated by $)
int 21h    ; call the DOS kernel

ret

