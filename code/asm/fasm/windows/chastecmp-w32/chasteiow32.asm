;This file manages displaying error messages in the case of something going wrong when opening a file.
;Unlike the Linux version of this header, it doesn't handle the actual opening of the files because I found it more convenient to handle it in the main function when using the Windows API.
;The links below are important for my reference when creating or opening files

;https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
;https://learn.microsoft.com/en-us/windows/win32/secauthz/generic-access-rights

code_2 db 'ENOENT No such file or directory',0
code_unknown db 'Unknown Error',0
open_ok db 'Opened OK',0

open_error_message db 'Error: ',0

;this function checks eax for an error.
;if there is an error opening a file during the "CreateFileA" function, eax returns -1

open_check_error:

cmp eax,-1
jnz error_none ;jump to end of function and do nothing if this is not an error

mov eax,file_error_message
call putstring
call [GetLastError]
call putint
call putspace

cmp eax,2
jz error_exist
jmp error_unknown

error_exist:
mov eax,code_2
jmp error_end

error_unknown:
mov eax,code_unknown
jmp error_end

error_end:
call putstring
call putline
mov eax,-1 ;set eax back to -1 so main program can still end by checking it

error_none:

ret
