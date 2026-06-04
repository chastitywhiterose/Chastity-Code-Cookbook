format ELF executable
main:

mov dword [radix],10
mov dword [int_width],1

;Linux system call to open a file

mov eax,5          ;invoke SYS_OPEN (kernel opcode 5)
mov ebx,filename   ;path to filename should be in eax before this function was called
mov ecx,101o       ;flags (in base 8) for open mode 0101 = 0100 (O_CREAT) + 1 (O_WRONLY)
mov edx,644o       ;permissions of the new file
int 80h            ;call the kernel

mov [filedesc],eax
call putint
mov eax,string1
call putstring

mov eax,string0    ;mov to eax the address of string to write
mov ecx,eax        ;pointer/address of string to write
call strlen        ;get length of the string in eax
mov edx,eax        ;copy length from eax to edx
mov ebx,[filedesc] ;write to the file descriptor
mov eax,4          ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h            ;system call to write the message

mov ebx,[filedesc] ;file number to close
mov eax,6          ;invoke SYS_CLOSE (kernel opcode 6)
int 80h            ;call the kernel

mov eax,1
mov ebx,0
int 80h

filename db 'newfile.txt',0
filedesc dd 0 ; file descriptor

string0 db 'This string writes to the file.',0Ah,0
string1 db '=file descriptor',0Ah,0

;a function to get the length of string in eax and return the integer in eax

strlen:

mov ebx,eax ; copy eax to ebx. ebx will be used as index to the string

strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp strlen_start

strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

mov eax,ebx ;copy the string length back to eax

ret

include 'chastelib32.asm'

; Information for understanding these system calls
; https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit
; find /usr/include -name "unistd_*"

; find /usr/include -name "unistd.h"

;find the filename containing file control constants
;find /usr/include -name "fcntl-linux.h"
;because this file contains these constants in octal
;#define O_RDONLY	     00
;#define O_WRONLY	     01
;#define O_RDWR		     02
;#define O_CREAT	   0100
