print_bytes_row:
mov eax,[file_offset]
mov [int_width],8
call putint
call putspace

mov esi,byte_array
next_hex:
push esi
mov ecx,0
mov cl,[esi]
mov eax,ecx
mov [int_width],2
call putint
call putspace

pop esi
inc esi
dec [bytes_read] 
cmp [bytes_read],0
jnz next_hex

call putline

ret



read_bytes_row:
    mov     edx, 0x10             ; number of bytes to read - one for each letter of the file contents
    mov     ecx, byte_array   ; move the memory address of our file contents variable into ecx
    mov     ebx, [filedesc]            ; move the opened file descriptor into EBX
    mov     eax, 3              ; invoke SYS_READ (kernel opcode 3)
    int     80h                 ; call the kernel

mov [bytes_read],eax
ret




; use the hex number in eax as an address to seek to in the file

file_seek:
mov     edx, 0              ; whence argument (SEEK_SET)
mov     ecx, eax            ; move the file cursor to this address
mov     ebx, [filedesc]     ; move the opened file descriptor into EBX
mov     eax, 19             ; invoke SYS_LSEEK (kernel opcode 19)
int     80h                 ; call the kernel
mov [file_offset],ecx ; move the new offset
ret





