;this function converts a string pointed to by ax into an integer returned in eax instead
;it is a little complicated because it has to account for whether the character in
;a string is a decimal digit 0 to 9, or an alphabet character for bases higher than ten
;it also checks for both uppercase and lowercase letters for bases 11 to 36
;finally, it checks if that letter makes sense for the base.
;For example, G to Z cannot be used in hexadecimal, only A to F can
;The purpose of writing this function was to be able to accept user input as integers

;this version of the strint function has been modified from its original version.
;it has been formatted to extract up to 32 bits of data using memory despite using
;only 16 bit registers.
;It uses the same [radix] and [int_width] variables as the regular 16 bit strint

;It uses local labels beginning with a dot(.) to avoid conflicts with the 16 bit version of this function

;the bp register is used for the indexing of which word is being written to in memory
;the si register is used for counting how many digits have been read


intwords dw 0,0 ;define 2 words(16 bits each). The initial value doesn't matter.
max_hex_digits dw 4; maximum number of hexadecimal digits that can fit in a word

strint_32:

mov bx,ax ;copy string address from ax to bx because eax will be replaced soon!
mov ax,0

;initialize both words to 0
mov [intwords],0
mov [intwords+1],0
;choose these registers for special meaning
mov bp,intwords ;set the bp register with address of where intwords start
mov si,0        ;we will use si register as a counting variable to keep track of how many digits read

.read_strint:
mov cx,0 ; zero ecx so only lower 8 bits are used
mov cl,[bx]
inc bx
cmp cl,0 ; compare byte at address edx with 0
jz .strint_end ; if comparison was zero, this is the end of string

;if char is below '0' or above '9', it is outside the range of these and is not a digit
cmp cl,'0'
jb .not_digit
cmp cl,'9'
ja .not_digit

;but if it is a digit, then correct and process the character
.is_digit:
sub cl,'0'
jmp .process_char

.not_digit:
;it isn't a digit, but it could be perhaps and alphabet character
;which is a digit in a higher base

;if char is below 'A' or above 'Z', it is outside the range of these and is not capital letter
cmp cl,'A'
jb .not_upper
cmp cl,'Z'
ja .not_upper

.is_upper:
sub cl,'A'
add cl,10
jmp .process_char

.not_upper:

;if char is below 'a' or above 'z', it is outside the range of these and is not lowercase letter
cmp cl,'a'
jb .not_lower
cmp cl,'z'
ja .not_lower

.is_lower:
sub cl,'a'
add cl,10
jmp .process_char

.not_lower:

;if we have reached this point, result invalid and end function
jmp .strint_end

.process_char:

cmp cx,[radix] ;compare char with radix
jae .strint_end ;if this value is above or equal to radix, it is too high despite being a valid digit/alpha




;push ax
;mov ax,si
;call putint
;pop ax

;important section
cmp si,[max_hex_digits] ;if we are at 4 digits written already
jz .next_word 
jmp .keep_word
.next_word:
mov [bp],ax ;if at max hex digits already, save this word and move to next
inc bp
mov ax,0 ;zero ax to avoid conflicts
mov cx,0
.keep_word:
mov dx,0 ;zero edx because it is used in mul sometimes
mul word [radix]    ;mul eax with radix
add ax,cx

inc si ;one more digit has been added to the integer




jmp .read_strint ;jump back and continue the loop if nothing has exited it

.strint_end:
mov [bp],ax ;save ax to the current word

ret
