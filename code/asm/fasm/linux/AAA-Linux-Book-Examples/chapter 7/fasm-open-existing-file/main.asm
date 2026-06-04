format ELF executable
main:

mov dword [radix],10
mov dword [int_width],1

;Linux system call to open an existing file

mov eax,5          ;invoke SYS_OPEN (kernel opcode 5)
mov ebx,filename   ;path to filename should be in eax before this function was called
mov ecx,0          ;flags for open mode 0=O_RDONLY
mov edx,0          ;permissions irrelevant because we are opening a file that exists
int 80h            ;call the kernel

push eax           ;save eax on the stack
mov [filedesc],eax ;also copy file descriptor to memory
call putint
mov eax,string1
call putstring
pop eax            ;restore eax from the stack

cmp eax,0 ;compare eax with zero to update flags
jns cat   ;if eax is not negative/signed there was no error

;Otherwise, if it was signed, then this code will display an error message.

mov eax,file_error
call putstring

jmp the_end ;end the program because we failed at opening the file

cat:

mov edx,1            ;number of bytes to read
mov ecx,tempbyte     ;address to store the bytes
mov ebx,[filedesc]   ;move the opened file descriptor into EBX
mov eax,3            ;invoke SYS_READ (kernel opcode 3 on 32 bit systems)
int 80h              ;call the kernel

cmp eax,0
jnz print_byte ;if more than zero bytes read, proceed to display
jmp the_end ;otherwise, end the program

;this point is reached if file was read from successfully

print_byte:

mov edx,1            ;number of bytes to write
mov ecx,tempbyte     ;address of the bytes
mov ebx,1            ;write to standard out instead of the file descriptor we read from
mov eax,4            ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h              ;call the kernel

jmp cat

cat_end:

mov ebx,[filedesc] ;file number to close
mov eax,6          ;invoke SYS_CLOSE (kernel opcode 6)
int 80h            ;call the kernel

the_end:
mov eax,1
mov ebx,0
int 80h

tempbyte db 0
filename db 'newfile.txt',0
filedesc dd 0 ; file descriptor
file_error db 'error while opening file',0Ah,0

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
