format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

loop_input:

mov eax,string0
call putstring

call getstring

mov esi,eax     ;mov the string address in eax to esi
mov edi,string3 ;mov the "exit" string address to edi
call strcmp     ;call the function to compare the strings and return eax
cmp eax,0       ;if eax is 0, the strings are the same
jz the_end      ;go to the_end if the user typed "exit"

mov eax,string1
call putstring

mov eax,buf
call putstring
call putline

mov eax,string2
call putstring

mov eax,[count]
dec eax
call putint
call putline

jmp loop_input

the_end:
mov eax,1
mov ebx,0
int 80h

string0 db 'Enter a string from the keyboard: ',0
string1 db 'string: ',0
string2 db 'length: ',0
string3 db 'exit',0

buf db 0x100 dup '?'
count dd 0
last_char db 0

;summary
;the getstring function is the reverse function of putstring
;instead of printing a string to standard output
;it reads a string from standard input (AKA the keyboard)

;details
;the getstring function is designed to get a string of text
;which is terminated by whitespace or any non printable character
;the idea is that multiple strings can be passed on one line
;separated by spaces, similar to command line arguments
;this function was written for the specific purpose of converting any of
;my programs that used command line arguments to read from stdin instead

getstring:

mov [count],0 ;set count of characters read during this function to zero
mov edx,1     ;number of bytes to read
mov ecx,buf   ;address to store the bytes

getstring_chars:

mov ebx,0     ;read from stdin
mov eax,3     ;invoke SYS_READ (kernel opcode 3)
int 80h       ;call the kernel

cmp eax,1             ;was 1 character read?
jz getstring_read_yes ;if yes, process this character and add to string
ret                   ;otherwise exit the function now

getstring_read_yes:
add [count],eax   ;add how many characters we have read
mov al,[ecx]      ;mov last character read into al register

;check if this character is in the proper range to be part of the string

cmp al,0x21      ;compare with 0x21 (!=exclamation)
jb getstring_end ;jump if below to getstring_end label
cmp al,0x7E      ;compare with 0x7E (tilde)
ja getstring_end ;jump if above to getstring_end label

;if neither jump happened, keep the character and

inc ecx       ;increment address where next byte is read from
jmp getstring_chars ;jump back to start of loop and keep reading

getstring_end:

mov [last_char],al ;save the last character read
mov byte[ecx],0 ;terminate this string with a zero

mov eax,buf ;mov the buffer address to eax for returning the string

ret


;Short Description of strcmp:
;strcmp compares the string at esi to the one at edi
;eax returns 0 if the strings are the same and non zero if different
;the algorithm is simple but I will explain it for those who are confused

;Long Description of strcmp:
;eax is initialized to zero
;a byte from each string is loaded into the al and bl registers
;the bytes are compared. if they are different, then we jump to the end
;However, if they are the same, then we check if one of them is zero
;for this purpose it doesn't matter whether we compare al or bl with zero
;because it is known that they are the same if the jnz did not take place
;if it is zero, this also jumps to the end of the function
;If neither jump took place, then we jump to the start of the loop
;but when the function finally ends bl will be subtracted from al
;this ensures that the function returns zero if the final characters are the same
;ebx,esi,and edi are preserved but eax is the return value
;also, the sub instruction at the end of the function also updates the flags
;so you can "jz" or "jnz" to a label after calling this function based on results
;This makes strcmp as useful for strings as the Intel "cmp" instruction is for integers

strcmp:

push ebx
push esi
push edi

mov eax,0

strcmp_start:

;read a byte from each string
mov al,[edi]
mov bl,[esi]
cmp al,bl
jnz strcmp_end

cmp al,0
jz strcmp_end

inc edi
inc esi

jmp strcmp_start

strcmp_end:
sub al,bl

pop edi
pop esi
pop ebx

ret

include 'chastelib32.asm'

