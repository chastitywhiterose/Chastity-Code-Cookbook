format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

call [GetCommandLineA]
call putstring

sub rsp,40
mov rcx,0
call [ExitProcess]

section '.idata' import data readable writeable
library kernel32, 'KERNEL32.DLL'
import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 GetCommandLineA, 'GetCommandLineA'
