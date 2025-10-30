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

;However, it uses an extra word variable in memory which is designed to store the upper 16 bits of
;a 32 bit offset for file seeking. Apparently the DOS system calls support this based on Ralf Browns interrupt list.
;I confirmed that it works.

;You might wonder why I made a 32 bit variant of this function rather than replacing the original. These are my reasons

;1. It only works with hexadecimal in the context of the chastehex program.
;2. This function stores extra data every loop and is therefore slower.
;3. Most of the time 32 bit data isn't needed as 16 bit DOS can't use 32 bit memory.

;This function was a specific case only meant for adding 32 bit support for the DOS version of chastehex.
;I also kept the original which only contains support for files less than 64 kilobytes.

extra_word dw 0 ;define an extra word(16 bits). The initial value doesn't matter.

strint_32:

;initialize new variables added to this function
mov [extra_word],0

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
