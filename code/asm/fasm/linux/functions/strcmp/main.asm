;Linux 32-bit Assembly Source for chastext
;a basic text search and replace program
format ELF executable
entry main

;a reduced form of chastelib without functions this program doesn't use
include 'chastelib32.asm'

main:

mov dword [radix],16 ; can choose radix for integer input/output!
mov dword [int_width],1

pop eax
mov [argc],eax ;save the argument count for later
;call putint_and_line

cmp dword [argc],2
ja help_skip ;if more than 1 argument is given, skip the help message and process the other arguments

help:
mov eax,help_message
call putstring
jmp main_end
help_skip:

pop eax ;pop the arg for program name but discard it

pop eax ;pop the first argument
mov [string0],eax
call putstr_and_line
mov eax,msg_strlen
call putstring
mov eax,[string0]
call strlen
call putint_and_line

pop eax ;pop the second argument
mov [string1],eax
call putstr_and_line
mov eax,msg_strlen
call putstring
mov eax,[string1]
call strlen
call putint_and_line

;move the two strings into the edi and esi registers for comparison
;my strlen function expects them to be pointed to by these registers

mov eax,msg_strcmp
call putstring

mov edi,[string0]
mov esi,[string1]
call strcmp

call putint_and_line

main_end:

mov eax, 1  ; invoke SYS_EXIT (kernel opcode 1)
mov ebx, 0  ; return 0 status on exit - 'No Errors'
int 80h

;the strlen and strcmp are named after the equivalent C functions
;but are written from scratch by me based on their expected behavior

;a function to get the length of string in eax and return the integer in eax

strlen:

mov ebx,eax ; copy eax to ebx. ebx will be used as index to the string

strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp strlen_start

strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

mov eax,ebx ;copy the string length back to eax

ret

;compare the string at esi to the one at edi
;eax returns 0 if the strings are the same and 1 if different

strcmp:

mov eax,0 ;this will be stay zero unless the strings are different

strcmp_start:

;read a byte from each string
mov bl,[edi]
mov bh,[esi]
cmp bl,bh ;compare these two bytes
jnz strcmp_end_diff ;if they are not equal, jump to difference label

;if the last jump was skipped, the bytes are equal
;so we do one more check to see if one of them is zero
cmp bl,0
jz  strcmp_end_same ;if it was zero, jump to sameness label

;go to next character of each string
inc edi
inc esi

jmp strcmp_start ;continue the loop

strcmp_end_diff: ;we jump here if there was a difference
inc eax ;if they were different, eax will be incremented and the function ends
strcmp_end_same:
;eax will remain zero if the same label was jumped to

ret

help_message db 'strcmp by Chastity White Rose',0xA
db 'This is an assembly program to compare two strings.',0xA
db 'strcmp string0 string1',0xA,0

msg_strlen db 'strlen=',0
msg_strcmp db 'strcmp=',0


argc    dd 0
string0 dd 0
string1 dd 0
