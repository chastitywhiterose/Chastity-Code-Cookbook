format PE64 console
entry main

include 'win64ax.inc' ; Includes standard Windows 64-bit definitions and macros

main:

sub rsp, 40 ;alignment

mov rcx,0
call [ExitProcess] ;exit after doing nothing

; FASM builds the Import Address Table (IAT) directly in the source file
section '.idata' import data readable writeable
    library kernel32, 'KERNEL32.DLL'

    import kernel32,\
           GetStdHandle, 'GetStdHandle',\
           WriteFile, 'WriteFile',\
           ExitProcess, 'ExitProcess'
