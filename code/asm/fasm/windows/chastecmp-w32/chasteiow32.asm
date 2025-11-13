;this file is for managing the advanced Input and Output situations that occur when opening and closing files.
;I use the following references when using system calls.


;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/errnos/


;before calling this function, make sure the eax register points to an address containing the filename as a zero terminated string
;this function opens a file for both reading and writing handle is returned in eax
;this function design is consistent with my other functions by using only eax as the input and output
;because it opens files for reading and writing, I do not need to be concerned with passing another argument for access mode

;However, this function actually does a whole lot more. It detects error codes by testing the sign bit and jumping to an error display system if eax is less than 0; Negative numbers are how errors are indicated on Linux. By turning the numbers positive, we get the actual error codes. The most common error codes that would occur are the following, either because a file doesn't exist, or because the user doesn't have permissions to read or write it.

code_2 db 'ENOENT No such file or directory',0
code_13 db 'EACCES Permission denied',0
code_unknown db 'Unknown Error',0
open_ok db 'Opened OK',0

open_error_message db 'Error: ',0

;this function checks eax for an error.
;if there is an error opening a file during the "CreateFileA" function, eax returns -1

open_check_error:

cmp eax,-1
jnz error_end

mov eax,file_error_message
call putstring
call [GetLastError]
call putint

;call putstring
;call putspace

cmp eax,2
jz error_exist

error_exist:
mov eax,code_2
jmp error_end

error_unknown:
mov eax,code_unknown
jmp error_end

error_end:

mov eax,-1 ;set eax back to -1 so main program can still end by checking it

ret

;this is the equivalent close call that expects eax to have the file handle we are closing
;technically it just passes it on to ebx but it is easier for me to remember if I use eax for everything

close:

mov ebx,eax ;file number to close
mov eax,6   ;invoke SYS_CLOSE (kernel opcode 6)
int 80h     ;call the kernel

ret

