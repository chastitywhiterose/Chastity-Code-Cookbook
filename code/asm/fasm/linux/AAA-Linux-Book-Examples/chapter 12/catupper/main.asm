format ELF executable

main:                   ;the main function of the assembly program

mov dword[radix],16     ;I can choose the radix for integer output!
mov dword[int_width],1  ;and the width of each integer for padded zeros

;Linux system call to open a file

mov ecx,2           ;open file in read and write mode 
mov ebx,filename    ;filename should be in eax before this function was called
mov eax,5           ;invoke SYS_OPEN (kernel opcode 5)
int 80h             ;call the kernel

mov dword [fd],eax  ;save the file descriptor returned in eax

cmp eax,0
jns cat_upper ;if eax is not negative/signed there was no error

;Otherwise, if it was signed/negative, display an error message.

neg eax                 ;turn the negative in eax positive
call putint_and_space   ;print the number in eax (error code) and space
mov eax,open_error      ;get the error message I defined
call putstr_and_line    ;print the error message and newline

jmp main_end        ;end the program because we can't open the file

cat_upper:

;use the read call to read 1 byte from the file

mov eax,3           ;invoke SYS_READ (kernel opcode 3)
mov ebx,[fd]        ;move the opened file descriptor into ebx
mov ecx,buf         ;address to store the byte
mov edx,1           ;number of bytes to read
int 80h             ;call the kernel

cmp eax,0           ;were zero bytes read?
jz cat_upper_end    ;if yes, then end the loop

;otherwise we assume 1 byte was read like we requested
;we print it to standard output so we can see what was in the file
;ecx and edx remain the same as in the read call above

mov eax,4           ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,1           ;write to stdout
int 80h             ;call the kernel

mov al,[buf]        ;move the byte we just read and wrote to al register

;if char is below 'a' or above 'z', it is not a lowercase letter
;if outside this range, we skip to the "al_is_not_lower" label

cmp al,'a'
jb al_is_not_lower
cmp al,'z'
ja al_is_not_lower

;otherwise, the al register contains a lowercase letter
;we will convert it to an uppercase letter with this formula
;and send it back to [buf]

sub al,'a'
add al,'A'
mov [buf],al

;next, we use an lseek call to go back to the offset we were at
;before we read the character in the first place

mov eax,19          ;invoke SYS_LSEEK (kernel opcode 19)
mov ebx,[fd]        ;move the opened file descriptor into ebx
mov ecx,[offset]    ;move the file cursor to this address
mov edx,0           ;whence argument (SEEK_SET)
int 80h             ;call the kernel

;and then we write the uppercase letter at the same place
;where it was a lowercase in the file!

mov eax,4           ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,[fd]        ;move the opened file descriptor into ebx
mov ecx,buf         ;address to store the byte
mov edx,1           ;number of bytes to write
int 80h             ;call the kernel

al_is_not_lower:

inc dword[offset]   ;increment offset

jmp cat_upper

cat_upper_end:

mov ebx,[fd]    ;file number to close
mov eax,6       ;invoke SYS_CLOSE (kernel opcode 6)
int 80h         ;call the kernel

main_end:

mov eax,1       ;exit (kernel opcode 1 on 32 bit systems)
mov ebx,0       ;return 0 status on exit - 'No Errors'
int 80h         ;system call for 32-bit Linux kernel

include 'chastelib32.asm'

filename db 'openthis.txt',0 ;name of the file
fd dd 0                      ;a place for the file descriptor
buf db 0                     ;a buffer containing 1 byte
offset dd 0                  ;offset to be used in lseek

open_error db 'error opening file',0
