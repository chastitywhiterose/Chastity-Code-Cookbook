;this file is for managing the advanced Input and Output situations that occur when opening and closing files.
;I use the following references when using system calls.


;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/errnos/


;before calling this function, make sure the eax register points to an address containing the filename as a zero terminated string
;this function opens a file for both reading and writing handle is returned in eax
;this function design is consistent with my other functions by using only eax as the input and output
;because it opens files for reading and writing, I do not need to be concerned with passing another argument for access mode

;However, this function actually does a whole lot more. It detects error codes by testing the sign bit and jumping to an error display system if eax is less than 0; Negative numbers are how errors are indicated on Linux. By turning the numbers positive, we get the actual error codes.

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