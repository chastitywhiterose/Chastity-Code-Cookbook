;this file is for managing the advanced Input and Output situations that occur when opening and closing files.
;I use the following references when using system calls.


;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/errnos/


;before calling this function, make sure the rax register points to an address containing the filename as a zero terminated string
;this function opens a file for both reading and writing handle is returned in rax
;this function design is consistent with my other functions by using only rax as the input and output
;because it opens files for reading and writing, I do not need to be concerned with passing another argument for access mode

;However, this function actually does a whole lot more. It detects error codes by testing the sign bit and jumping to an error display system if rax is less than 0; Negative numbers are how errors are indicated on Linux. By turning the numbers positive, we get the actual error codes. The most common error codes that would occur are the following, either because a file doesn't exist, or because the user doesn't have permissions to read or write it.

; 2 0x02 ENOENT No such file or directory
;13 0x0d EACCES Permission denied

open_error_message db 'File Error Code: ',0

open:

mov rsi,2   ;open file in read and write mode 
mov rdi,rax ;filename should be in rax before this function was called
mov rax,2   ;invoke SYS_OPEN (kernel opcode 2 on 64 bit systems)
syscall     ;call the kernel

cmp rax,0
js open_error
jmp open_end

open_error:

neg rax ;invert sign to get errno code
push rax
mov rax,open_error_message
call putstring
pop rax
call putint
call putline
neg rax ;return rax to original sign

open_end:

ret

;this is the equivalent close call that expects rax to have the file handle we are closing
;technically it just passes it on to rdi but it is easier for me to remember if I use rax for everything

close:

mov rdi,rax ;file number to close
mov rax,3   ;invoke SYS_CLOSE (kernel opcode 3 for 64 bit Intel)
syscall     ;call the kernel

ret

