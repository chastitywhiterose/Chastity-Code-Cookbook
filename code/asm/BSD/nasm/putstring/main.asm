%include 'bsd-putstring.asm'

	section	.text
	global _start
_start:
	mov eax,hello
	call putstring

	mov ebx, 0  ; return 0 status on exit - 'No Errors'
	mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
	push ebx
	push eax
        int 80h

	section	.data
	hello	db	'Hello, World!', 0Ah,0
