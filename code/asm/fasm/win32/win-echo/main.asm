format PE console
include 'win32ax.inc'
include 'chastelibw32.asm'

main:

mov [radix],10 ; Choose radix for integer output.
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

;display the arg string to make sure it is working correctly
mov eax,[arg_start]
call putstring
call putline

;print the length in bytes of the arg string
mov eax,[arg_length]
call putint

;this loop will filter the string, replacing all spaces with zero
mov ebx,[arg_start]
arg_filter:
cmp byte [ebx],' '
ja notspace ; if char is above space, leave it alone
mov byte [ebx],0 ;otherwise it counts as a space, change it to a zero
notspace:
inc ebx
cmp ebx,[arg_end]
jnz arg_filter

arg_filter_end:

;optionally print first arg (name of program)
mov eax,[arg_start]
call putstring
call putline

;this loop is very safe because it only prints arguments if they are valid
;if the end of the args are reached by comparison of eax with [arg_end]
;then it will jump to args_none and proceed from there
args_list:
call get_next_arg
cmp eax,[arg_end]
jz args_none
call putstring
call putline
jmp args_list
args_none:

;Exit the process with code 0
push 0
call [ExitProcess]

.end main

arg_start  dd 0 ;start of arg string
arg_end    dd 0 ;address of the end of the arg string
arg_length dd 0 ;length of arg string
arg_spaces dd 0 ;how many spaces exist in the arg command line

;function to move ahead to the next art
;only works after the filter has been applied to turn all spaces into zeroes
get_next_arg:
mov ebx,[arg_start]
find_zero:
cmp byte [ebx],0
jz found_zero
inc ebx
jmp find_zero ; this char is not zero, go to the next char
found_zero:

find_non_zero:
cmp ebx,[arg_end]
jz arg_finish ;if ebx is already at end, nothing left to find
cmp byte [ebx],0
jnz arg_finish ;if this char is not zero we have found the next string!
inc ebx
jmp find_non_zero ;otherwise, keep looking

arg_finish:
mov [arg_start],ebx ; save this index to variable
mov eax,ebx ;but also save it to ax register for use
ret
;we can know that there are no more arguments when
;the either [arg_start] or eax are equal to [arg_end]
