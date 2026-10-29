format PE console
entry main

include 'win32a.inc'
include 'chastelib-w32.asm'

main:

call [GetCommandLineA]
call putstring

push 0
call [ExitProcess]

section '.idata' import data readable writeable
library kernel32, 'KERNEL32.DLL'
import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess',\
 GetCommandLineA, 'GetCommandLineA'
