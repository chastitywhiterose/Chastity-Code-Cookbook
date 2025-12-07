%include 'bsd-chastelib32.asm'

	section	.text
	global _start
_start:

	mov dword [radix],10    ;can choose radix for integer output!
;	mov dword [int_width],1

;	mov eax,1987
;	call putint

	mov eax,hello
	call putstring

	mov ebx, 0  ; return 0 status on exit - 'No Errors'
	mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
	push ebx
	push eax
        int 80h

	section	.data
	hello	db	'Hello, World!', 0Ah,0
