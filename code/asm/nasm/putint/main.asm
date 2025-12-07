global  _start
 
_start:

mov dword [radix],10 ; can choose radix for integer output!
mov dword [int_width],1

	mov eax,666
	;call putint

 
	mov eax,msg
	call putstring


	mov ebx, 0      ; return 0 status on exit - 'No Errors'
	mov eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
	int 80h

	msg db 'Hello World!', 0Ah,0     ; assign msg variable with your message string

%include 'putstring32.asm'
%include 'putint32.asm'
