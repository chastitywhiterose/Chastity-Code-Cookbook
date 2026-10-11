debug_registers:

mov [temp_reg],eax

mov eax,name_reg
call putstring

mov eax,name_eax
call putstring
mov eax,[temp_reg]
call putint_and_line

mov eax,name_ebx
call putstring
mov eax,ebx
call putint_and_line

mov eax,name_ecx
call putstring
mov eax,ecx
call putint_and_line

mov eax,name_edx
call putstring
mov eax,edx
call putint_and_line

mov eax,name_edi
call putstring
mov eax,edi
call putint_and_line

mov eax,name_esi
call putstring
mov eax,esi
call putint_and_line

mov eax,name_ebp
call putstring
mov eax,ebp
call putint_and_line

mov eax,name_esp
call putstring
mov eax,esp
call putint_and_line

mov eax,[temp_reg]

ret

temp_reg: dd 0
name_reg: db 'Registers:',0xD,0xA,0
name_eax: db 'eax ',0 
name_ebx: db 'ebx ',0
name_ecx: db 'ecx ',0
name_edx: db 'edx ',0
name_edi: db 'edi ',0 
name_esi: db 'esi ',0
name_ebp: db 'ebp ',0
name_esp: db 'esp ',0
