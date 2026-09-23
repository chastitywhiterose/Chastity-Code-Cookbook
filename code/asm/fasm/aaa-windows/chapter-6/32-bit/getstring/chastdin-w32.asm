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
count dd 0
last_char db 0

;read only 1 byte using Win32 ReadFile system call.
;this function is the only place in my source where I read from standard input
;this keeps my code simple because even reading 1 character
;requires this long series of stack commands
;if I tried to use the ReadFile system call in multiple places,
;it would lead to a lot of code bloat in both source and binary
;getstring and getline both use this function for all input
getchar:
push 0              ;Optional Overlapped Structure 
push count          ;Store Number of Bytes Read from this call
push 1              ;Number of bytes to read
push last_char      ;address to store bytes
push -10            ;STD_INPUT_HANDLE = Negative Ten
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
call [ReadFile]
xor eax,eax         ;set eax to 0
mov al,[last_char]  ;set lowest part of eax to key read
ret

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

mov ebx,buf       ;address to store the bytes

getstring_chars:

call getchar      ;reads one character and stores in al register
cmp [count],1     ;was 1 character read?
jnz getstring_end ;if not, then end this loop

mov [ebx],al      ;mov last character read into buffer

;check if this character is in the proper range to be part of the string

cmp al,0x21       ;compare with 0x21 (!=exclamation)
jb getstring_end  ;jump if below to getstring_end label
cmp al,0x7E       ;compare with 0x7E (tilde)
ja getstring_end  ;jump if above to getstring_end label

;if neither jump happened, keep the character and
inc ebx             ;increment address where next byte is stored
jmp getstring_chars ;jump back to start of loop and keep reading

getstring_end:

mov byte[ebx],0 ;terminate this string with a zero

sub ebx,buf     ;subtract buf from current ebx to get length
mov [count],ebx ;store the length of string in count variable

mov eax,buf ;mov the buffer address to eax for returning the string

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

mov ebx,buf       ;address to store the bytes

getline_chars:

call getchar      ;reads one character and stores in al register
cmp [count],1     ;was 1 character read?
jnz getstring_end ;if not, then end this loop

mov [ebx],al      ;mov last character read into buffer

;check if this character is in the proper range to be part of the string

cmp al,0x20    ;compare with 0x20 (space)
jb getline_end ;jump if below to getstring_end label
cmp al,0x7E    ;compare with 0x7E (tilde)
ja getline_end ;jump if above to getstring_end label

;if neither jump happened, keep the character and
inc ebx             ;increment address where next byte is stored
jmp getline_chars ;jump back to start of loop and keep reading

getline_end:

mov byte[ebx],0 ;terminate this string with a zero

sub ebx,buf     ;subtract buf from current ebx to get length
mov [count],ebx ;store the length of string in count variable

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

;Short Description of strlen:
;The strlen function gets the length of string in eax and returns it in eax
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

push ebx
mov ebx,eax     ;copy eax to ebx. ebx will be used as index to the string

strlen_start:   ;this loop finds the length of the string

cmp byte[ebx],0 ;compare byte at address ebx with 0
jz strlen_end   ;if comparison was zero, jump to loop end
inc ebx
jmp strlen_start

strlen_end:
sub ebx,eax     ;subtract start pointer from current pointer to get length of string
mov eax,ebx     ;copy the string length back to eax
pop ebx

ret



