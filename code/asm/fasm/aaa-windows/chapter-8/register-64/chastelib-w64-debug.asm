debug_registers:

mov [temp_reg],rax

mov rax,name_reg
call putstring

mov rax,name_rax
call putstring
mov rax,[temp_reg]
call putint_and_line

mov rax,name_rbx
call putstring
mov rax,rbx
call putint_and_line

mov rax,name_rcx
call putstring
mov rax,rcx
call putint_and_line

mov rax,name_rdx
call putstring
mov rax,rdx
call putint_and_line

mov rax,name_rdi
call putstring
mov rax,rdi
call putint_and_line

mov rax,name_rsi
call putstring
mov rax,rsi
call putint_and_line

mov rax,name_rbp
call putstring
mov rax,rbp
call putint_and_line

mov rax,name_rsp
call putstring
mov rax,rsp
call putint_and_line

mov rax,name_r8
call putstring
mov rax,r8
call putint_and_line

mov rax,name_r9
call putstring
mov rax,r9
call putint_and_line

mov rax,name_r10
call putstring
mov rax,r10
call putint_and_line

mov rax,name_r11
call putstring
mov rax,r11
call putint_and_line

mov rax,name_r12
call putstring
mov rax,r12
call putint_and_line

mov rax,name_r13
call putstring
mov rax,r13
call putint_and_line

mov rax,name_r14
call putstring
mov rax,r14
call putint_and_line

mov rax,name_r15
call putstring
mov rax,r15
call putint_and_line

mov rax,[temp_reg]

ret

temp_reg: dq 0
name_reg: db 'Registers:',0xD,0xA,0
name_rax: db 'rax ',0 
name_rbx: db 'rbx ',0
name_rcx: db 'rcx ',0
name_rdx: db 'rdx ',0
name_rdi: db 'rdi ',0 
name_rsi: db 'rsi ',0
name_rbp: db 'rbp ',0
name_rsp: db 'rsp ',0
;extended registers
 name_r8: db ' r8 ',0 
 name_r9: db ' r9 ',0
name_r10: db 'r10 ',0
name_r11: db 'r11 ',0
name_r12: db 'r12 ',0 
name_r13: db 'r13 ',0
name_r14: db 'r14 ',0
name_r15: db 'r15 ',0
