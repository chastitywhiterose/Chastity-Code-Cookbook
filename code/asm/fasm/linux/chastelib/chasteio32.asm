;this file is for managing the advanced Input and Output situations that occur when opening and closing files.
;I use the following online references when using system calls.

;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86_64-64-bit
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/errnos/

;Linux distros vary on the location of files, but on my system, the syscall numbers can also be found here.
;The numbers are different for 32 and 64 bit

;/usr/include/x86_64-linux-gnu/asm/unistd_32.h
;/usr/include/x86_64-linux-gnu/asm/unistd_64.h

;In addition to those resources for Assembly file IO, the following file contains the access modes for opening a file

;/usr/include/asm-generic/fcntl.h

;0 open file in read only mode
;1 open file in write only mode
;2 open file in read and write mode

;For the most part, mode 2 will allow reading a writing of any file as long as that file already exists.
;See https://asmtutor.com/#lesson22 for an example of creating a new file

;Notes on Chastity's open function

;before calling the open function, make sure the eax register points to an address containing the filename as a zero terminated string
;this function opens a file for both reading and writing handle is returned in eax
;this function design is consistent with my other functions by using only eax as the input and output
;because it opens files for reading and writing, I do not need to be concerned with passing another argument for access mode

;However, this function actually does a whole lot more. It detects error codes by testing the sign bit and jumping to an error display system if eax is less than 0; Negative numbers are how errors are indicated on Linux. By turning the numbers positive, we get the actual error codes. The most common error codes that would occur are the following, either because a file doesn't exist, or because the user doesn't have permissions to read or write it.

; 2 0x02 ENOENT No such file or directory
;13 0x0d EACCES Permission denied

open_error_message db 'File Error Code: ',0

open:

mov ecx,2   ;open file in read and write mode 
mov ebx,eax ;filename should be in eax before this function was called
mov eax,5   ;invoke SYS_OPEN (kernel opcode 5)
int 80h     ;call the kernel

cmp eax,0
js open_error
jmp open_end

open_error:

neg eax ;invert sign to get errno code
push eax
mov eax,open_error_message
call putstring
pop eax
call putint
call putline
neg eax ;return eax to original sign

open_end:

ret

;this is the equivalent close call that expects eax to have the file handle we are closing
;technically it just passes it on to ebx but it is easier for me to remember if I use eax for everything

close:

mov ebx,eax ;file number to close
mov eax,6   ;invoke SYS_CLOSE (kernel opcode 6)
int 80h     ;call the kernel

ret

