print_bytes_row:
mov [int_string_end],' '
mov eax,[file_offset]
call putint

mov esi,byte_array
next_hex:
push esi
mov ecx,0
mov cl,[esi]
mov eax,ecx
call putint

pop esi
inc esi
dec [bytes_read] 
cmp [bytes_read],0
jnz next_hex

mov eax,newline
call putstring

ret



read_bytes_row:
    mov     edx, 0x10             ; number of bytes to read - one for each letter of the file contents
    mov     ecx, byte_array   ; move the memory address of our file contents variable into ecx
    mov     ebx, [filedesc]            ; move the opened file descriptor into EBX
    mov     eax, 3              ; invoke SYS_READ (kernel opcode 3)
    int     80h                 ; call the kernel

mov [bytes_read],eax
ret