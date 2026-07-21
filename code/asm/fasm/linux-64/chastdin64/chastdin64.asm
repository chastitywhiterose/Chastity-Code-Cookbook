;Chastity's Standard Input header file
;The functions here are designed to read strings and numbers from standard input.

;getstring ;read characters from stdin until the first whitespace
;getline   ;read characters from stdin until the first newline,EOF,tab,etc.
;strcmp    ;compare two strings similar to the same function in C
;strlen    ;get length of string similar to the same function in C

;these variables are used as the default controllers
;for the getstring and getline functions
;buf stores keyboard input during those functions
;count stores how many bytes were read
;last_char stores the last character read
;usually this will be a space, tab, or newline

buf db 0x100 dup '?'
count dq 0
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
mov rdx,1     ;number of bytes to read
mov rsi,buf   ;address to store the bytes

getstring_chars:

mov rdi,0     ;read from stdin
mov rax,0     ;invoke SYS_READ (kernel opcode 0 on 64 bit Intel)
syscall       ;call the kernel

cmp rax,1     ;was 1 character read?
jnz getstring_end ; if not, then end this loop

mov al,[rsi]  ;mov last character read into al register

;check if this character is in the proper range to be part of the string

cmp al,0x21      ;compare with 0x21 (!=exclamation)
jb getstring_end ;jump if below to getstring_end label
cmp al,0x7E      ;compare with 0x7E (tilde)
ja getstring_end ;jump if above to getstring_end label

;if neither jump happened, keep the character and

inc [count]   ;increment how many characters we have read
inc rsi       ;increment address where next byte is read from
jmp getstring_chars ;jump back to start of loop and keep reading

getstring_end:

mov [last_char],al ;save the last character read
mov byte[rsi],0 ;terminate this string with a zero

mov rax,buf ;mov the buffer address to eax for returning the string

ret

;the getline function gets an entire line of text from the keyboard
;calling this function allows for a string that can contain spaces
;it considers as anything outside the range of 0x20 to 0x7E as the end of line character
;this is because the end of the line might be 0x0A on Linux
;or it might be 0x0D,0x0A on DOS or Windows.
;technically, it means tab will also terminate a line
;the intended use of this function is to read a filename
;This makes sense because filenames can contain spaces

getline:

mov [count],0 ;set count of characters read during this function to zero
mov rdx,1     ;number of bytes to read
mov rsi,buf   ;address to store the bytes

getline_chars:

mov rdi,0     ;read from stdin
mov rax,0     ;invoke SYS_READ (kernel opcode 0 on 64 bit Intel)
syscall       ;call the kernel

cmp rax,1     ;was 1 character read?
jnz getline_end ; if not, then end this loop

mov al,[rsi]  ;mov last character read into al register

;check if this character is in the proper range to be part of the string

cmp al,0x20    ;compare with 0x20 (space)
jb getline_end ;jump if below to getstring_end label
cmp al,0x7E    ;compare with 0x7E (tilde)
ja getline_end ;jump if above to getstring_end label

;if neither jump happened, keep the character and

inc [count]       ;increment how many characters we have read
inc rsi           ;increment address where next byte is read from
jmp getline_chars ;jump back to start of loop and keep reading

getline_end:

mov [last_char],al ;save the last character read
mov byte[rsi],0    ;terminate this string with a zero

mov rax,buf ;mov the buffer address to eax for returning the string

ret

;Short Description of strcmp:
;strcmp compares the string at rsi to the one at rdi
;rax returns 0 if the strings are the same and non zero if different
;the algorithm is simple but I will explain it for those who are confused

;Long Description of strcmp:
;rax is initialized to zero
;a byte from each string is loaded into the al and bl registers
;the bytes are compared. if they are different, then we jump to the end
;However, if they are the same, then we check if one of them is zero
;for this purpose it doesn't matter whether we compare al or bl with zero
;because it is known that they are the same if the jnz did not take place
;if it is zero, this also jumps to the end of the function
;If neither jump took place, then we jump to the start of the loop
;but when the function finally ends bl will be subtracted from al
;this ensures that the function returns zero if the final characters are the same
;rbx,rsi,and rdi are preserved but rax is the return value
;also, the sub instruction at the end of the function also updates the flags
;so you can "jz" or "jnz" to a label after calling this function based on results
;This makes strcmp as useful for strings as the Intel "cmp" instruction is for integers

strcmp:

push rbx
push rsi
push rdi

mov rax,0

strcmp_start:

;read a byte from each string
mov al,[rdi]
mov bl,[rsi]
cmp al,bl
jnz strcmp_end

cmp al,0
jz strcmp_end

inc rdi
inc rsi

jmp strcmp_start

strcmp_end:
sub al,bl

pop rdi
pop rsi
pop rbx

ret

;Short Description of strlen:
;The strlen function gets the length of string in rax and returns it in rax
;This is the same algorithm used in my putstring function but is independent of an operating system.

;Long Description of strlen:
;The strlen function is rarely used but there are time when knowing the length of a string is helpful.
;First, I needed it for my chastext program when I wanted to compare strings
;To search for text in a file, I had to first get the length of the string which was being searched for.
;By knowing the string length, I can read that many bytes from the file.
;That way, if fewer bytes were read from the file than required, I can end the program without requiring strcmp to be called.
;Comparing incomplete data would give untrackable results.
;The second time I might need string length is when I am converting a number to a string in a specific radix using intstr.
;If I know how many characters are in the highest number in an integer sequence,
;I can then customize the integer width so that all digits are lined up.
;My chastelib library was designed with integer sequences as the priority.

strlen:

push rbx
mov rbx,rax     ;copy rax to rbx. rbx will be used as index to the string

strlen_start:   ;this loop finds the length of the string

cmp byte[rbx],0 ;compare byte at address rbx with 0
jz strlen_end   ;if comparison was zero, jump to loop end
inc rbx
jmp strlen_start

strlen_end:
sub rbx,rax     ;subtract start pointer from current pointer to get length of string
mov rax,rbx     ;copy the string length back to rax
pop rbx

ret


