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


extra_word dw 0 ;define an extra word(16 bits). The initial value doesn't matter.
hex_digit_counter dw 0 ;a counting variable

strint_32:

;initialize new variables added to this function
mov [extra_word],0
mov [hex_digit_counter],0

mov bx,ax ;copy string address from ax to bx because eax will be replaced soon!
mov ax,0

read_strint_32:
mov cx,0 ; zero ecx so only lower 8 bits are used
mov cl,[bx]
inc bx
cmp cl,0 ; compare byte at address edx with 0
jz strint_end_32 ; if comparison was zero, this is the end of string

;if char is below '0' or above '9', it is outside the range of these and is not a digit
cmp cl,'0'
jb not_digit_32
cmp cl,'9'
ja not_digit_32

;but if it is a digit, then correct and process the character
is_digit_32:
sub cl,'0'
jmp process_char_32

not_digit_32:
;it isn't a digit, but it could be perhaps and alphabet character
;which is a digit in a higher base

;if char is below 'A' or above 'Z', it is outside the range of these and is not capital letter
cmp cl,'A'
jb not_upper_32
cmp cl,'Z'
ja not_upper_32

is_upper_32:
sub cl,'A'
add cl,10
jmp process_char

not_upper_32:

;if char is below 'a' or above 'z', it is outside the range of these and is not lowercase letter
cmp cl,'a'
jb not_lower_32
cmp cl,'z'
ja not_lower_32

is_lower_32:
sub cl,'a'
add cl,10
jmp process_char_32

not_lower_32:

;if we have reached this point, result invalid and end function
jmp strint_end_32

process_char_32:

cmp cx,[radix] ;compare char with radix
jae strint_end_32 ;if this value is above or equal to radix, it is too high despite being a valid digit/alpha

;before we process the character, to avoid data loss, we shift bits into the [extra_word]
push ax
shr ax,12 ;shift exactly 12 bits to keep the lowest hex digit of ax
shl [extra_word],4 ;shift the [extra_word] 4 bits to make room for the hex digit 
add [extra_word],ax
pop ax

mov dx,0 ;zero edx because it is used in mul sometimes
mul word [radix]    ;mul eax with radix
add ax,cx

jmp read_strint_32 ;jump back and continue the loop if nothing has exited it

strint_end_32:

ret
