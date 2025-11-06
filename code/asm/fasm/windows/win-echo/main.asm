format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov eax,main_string
call putstring

mov [radix],10 ; Choose radix 10 for integer output!
mov [int_width],1

;get command line argument string
call [GetCommandLineA]

mov [arg_start],eax ;back up eax to restore later

;short routine to find the length of the string
;and whether arguments are present
mov ebx,eax
find_arg_length:
cmp [ebx], byte 0
jz found_arg_length
inc ebx
jmp find_arg_length
found_arg_length:
;at this point, ebx has the address of last byte in string which contains a zero
;we will subtract to get and store the length of the string
mov [arg_end],ebx
sub ebx,eax
mov eax,ebx
mov [arg_length],eax
call putint

;display the string to make sure it is working correctly
mov eax,[arg_start]
call putstring

;this loop will filter the string, replacing all spaces with zero
mov ebx,[arg_start]
arg_filter

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

arg_start  dd 0 ;start of arg string
arg_end    dd 0 ;address of the end of the arg string
arg_length dd 0 ;length of arg string
arg_spaces dd 0 ;how many spaces exist in the arg command line

;A string to test if output works
main_string db 'Hello World!',0Ah,0
;test string of integer for input
test_int db '10011101001110011110011',0
