format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov eax,string0
call putstring

call getstring

mov eax,string1
call putstring

mov eax,buf
call putstring
call putline

mov eax,string2
call putstring

mov eax,[count]
call putint
call putline

the_end:
mov eax,1
mov ebx,0
int 80h

string0 db 'Enter a string from the keyboard: ',0
string1 db 'The string you entered is: ',0
string2 db 'The length of the string you entered is: ',0

buf db 0x100 dup '?'
count dd 0



getstring:

mov [count],0 ;set count of characters read during this function to zero
mov edx,1     ;number of bytes to read
mov ecx,buf   ;address to store the bytes

getstring_chars:

mov ebx,0     ;read from stdin
mov eax,3     ;invoke SYS_READ (kernel opcode 3)
int 80h       ;call the kernel

cmp eax,1     ;was 1 character read?
jnz getstring_end ; if not, then end this loop

mov al,[ecx]  ;mov last character read into al register

;check if this character is in the proper range to be part of the string

cmp al,0x20      ;compare with 0x20 (space)
jb getstring_end ;jump if below to getstring_end label
cmp al,0x7E      ;compare with 0x7E (tilde)
ja getstring_end ;jump if above to getstring_end label

;if neither jump happened, keep the character and

inc [count]   ;increment how many characters we have read
inc ecx       ;increment address where next byte is read from
jmp getstring_chars ;jump back to start of loop and keep reading

getstring_end:

mov byte[ecx],0 ;terminate this string with a zero

mov eax,buf ;mov the buffer address to eax for returning the string

ret

include 'chastelib32.asm'

