;Chastity's Standard Input header file
;The functions here are designed to read strings and numbers from standard input.


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

;the getline function gets an entire line of text from the keyboard
;calling this function allows for a string that can contain spaces

getline:

mov [count],0 ;set count of characters read during this function to zero
mov edx,1     ;number of bytes to read
mov ecx,buf   ;address to store the bytes

getline_chars:

mov ebx,0     ;read from stdin
mov eax,3     ;invoke SYS_READ (kernel opcode 3)
int 80h       ;call the kernel

cmp eax,1     ;was 1 character read?
jnz getline_end ; if not, then end this loop

mov al,[ecx]  ;mov last character read into al register

;check if this character is in the proper range to be part of the string

cmp al,0x20    ;compare with 0x20 (space)
jb getline_end ;jump if below to getstring_end label
cmp al,0x7E    ;compare with 0x7E (tilde)
ja getline_end ;jump if above to getstring_end label

;if neither jump happened, keep the character and

inc [count]       ;increment how many characters we have read
inc ecx           ;increment address where next byte is read from
jmp getline_chars ;jump back to start of loop and keep reading

getline_end:

mov byte[ecx],0 ;terminate this string with a zero

mov eax,buf ;mov the buffer address to eax for returning the string

ret



;strcmp compares the string at esi to the one at edi
;eax returns 0 if the strings are the same and 1 if different
;the algorithm is simple but I will explain it for those who are confused

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
