; chastelib assembly header file for 32 bit Linux
; This file is where I keep the source of my most important Assembly functions
; These are my string and integer output and conversion routines.

; To simplify documentation. The Accumulator/Arithmetic register
; (ax,eax,rax) depending on bit size shall be referred to as register A
; for the description of these core functions because the A register
; is treated special both by the Intel company and my code;

; putstring; Prints a zero terminated string from the address pointer to by A register.
; intstr;    Converts the number in A into a zero terminated string and points A to that address
; putint;    Prints the integer in A by calling intstr and then putstring.
; strint;    Converts the zero terminated string into an integer and sets A to that value
   
; Now, the source of the functions begins, with comments included for parts that I felt needed explanation.

putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Write string using Linux Write system call.
;Reference for 32 bit x86 syscalls is below.
;https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit

mov edx,ebx      ;number of bytes to write
mov ecx,eax      ;pointer/address of string to write
mov ebx,1        ;write to the STDOUT file
mov eax,4        ;write (kernel opcode 4 on 32 bit systems)
int 80h          ;system call for 32-bit Linux kernel

pop edx
pop ecx
pop ebx
pop eax

ret ;this is the end of the putstring function return to calling location

line db 0Ah,0 ;a string containing only a newline

;the next function which pushes eax to the stack
;moves the address of the line string and prints it with putstring
;then it pops the original value of eax back from the stack before the function returns
;this allows me to print a newline anywhere in the code without a single register changing

putline:
push eax
mov eax,line
call putstring
pop eax
ret

;a function for printing a single character that is the value of al

char: db 0,0

putchar:
push eax
mov [char],al
mov eax,char
call putstring
pop eax
ret

;a small function just for the common operation of
;printing a string followed by a line feed
;this saves a few bytes in the assembled code
;by reducing the number of function calls in the main program
;it also means we don't need to include a newline in every string!

putstr_and_line:
call putstring
call putline
ret