;this file is dedicated to using ANSI escape codes in Assembly programs.
;Using special strings of text, it is possible to reposition the cursor in Linux terminal programs
;Below are some links where I learned about ANSI escape sequences;

;https://notes.burke.libbey.me/ansi-escape-codes/
;https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

;There will be mostly example strings defined in here. The idea is for reminding myself how these things work.

;changing colors
ansi_red: db 0x1b,'[1;31m',0
ansi_green: db 0x1b,'[1;32m',0
ansi_yellow: db 0x1b,'[1;33m',0
ansi_blue: db 0x1b,'[1;34m',0
ansi_magenta: db 0x1b,'[1;35m',0
ansi_cyan: db 0x1b,'[1;36m',0
ansi_white: db 0x1b,'[1;37m',0

;this part is important!
;for maximum speed I embedded some ANSI sequence strings directly into the program
;Writing dynamic functions by hand was extremely error prone and still required loading the right
;registers with the arguments to the function. Therefore, unlike with the C programming language, the strings
;should be included directly. Every location is meant to be hard coded anyway

ansi_home: db 0x1b,'[H',0 ;move cursor to top left (Home)
ansi_clear: db 0x1b,'[2J',0 ;erase entire screen

;Global variables for x and y geometric positions on the screen
;These may be used in special escape sequences to reposition the cursor.
;unlike the hardcoded strings above, the cursor must be movable dynamically

x dd 0
y dd 0

prefix_x db "x=",0
prefix_y db "y=",0

ansi_string db 32 dup 0 ;string storage for buildable ansi sequence.

  red dd 0xFF
green dd 0
 blue dd 0x85

set_text_rgb:

mov [radix],10    ;set the radix to ten for escape sequences
mov [int_width],1

mov edi,ansi_string
mov [edi],byte 0x1B ;all escape sequences start with the escape character.
inc edi

mov [edi],byte '['
inc edi

mov [edi],byte '3'
inc edi
mov [edi],byte '8'
inc edi
mov [edi],byte ';'
inc edi
mov [edi],byte '2'
inc edi
mov [edi],byte ';'
inc edi

;copy the red component
mov eax,[red]
call intstr ; get the string for y
mov esi,eax ; set source index to the new integer string
call strcpy
mov [edi],byte ';'
inc edi

;copy the green component
mov eax,[green]
call intstr ; get the string for y
mov esi,eax ; set source index to the new integer string
call strcpy
mov [edi],byte ';'
inc edi

;copy the blue component
mov eax,[blue]
call intstr ; get the string for y
mov esi,eax ; set source index to the new integer string
call strcpy

mov [edi],byte 'm' ;finish the escape code for setting cursor position
inc edi
mov [edi],byte 0 ;terminate the string with zero

mov eax,ansi_string
call putstring

mov [radix],16

ret









move_cursor:

mov [radix],10    ;set the radix to ten for escape sequences
mov [int_width],1

mov edi,ansi_string
mov [edi],byte 0x1B ;all escape sequences start with the escape character.
inc edi

mov [edi],byte '['
inc edi

mov eax,[y]
inc eax
call intstr ; get the string for y

mov esi,eax ; set source index to the new integer string
call strcpy

mov [edi],byte ';'
inc edi

mov eax,[x]
inc eax
call intstr ; get the string for x

mov esi,eax ; set source index to the new integer string
call strcpy


mov [edi],byte 'H' ;finish the escape code for setting cursor position
inc edi
mov [edi],byte 0 ;terminate the string with zero

mov eax,ansi_string
call putstring

mov [radix],16

ret

;copies bytes from address edi to esi until a zero is found
;This is not optimized for speed because it doesn't use the special x86 instructions for that purpose.
;However, it is easily portable to any CPU I might write assembly for, if I choose which registers to use for that purpose.
;However, since this is an x86 function, I use edi(destination index) and esi(source index) in their traditional contexts

strcpy:

;jmp strcpy_end

mov al,[esi]
cmp al,0
jz strcpy_end
mov [edi],al
inc edi
inc esi
jmp strcpy

strcpy_end:
ret








;this function will process the key value and then accordingly operate the editor
;the getchar function stores the key in the [key] memory location and the al register

hexplore_input:

;obtain selected byte for proper indexing changes
mov ebx,[RAM_y_select]
shl ebx,4
add ebx,[RAM_x_select]
add ebx,RAM

cmp al,'0'
jz key_is_0
cmp al,'1'
jz key_is_1
cmp al,'2'
jz key_is_2
cmp al,'3'
jz key_is_3
cmp al,'4'
jz key_is_4
cmp al,'5'
jz key_is_5
cmp al,'6'
jz key_is_6
cmp al,'7'
jz key_is_7
cmp al,'8'
jz key_is_8
cmp al,'9'
jz key_is_9

cmp al,'a'
jz key_is_a
cmp al,'b'
jz key_is_b
cmp al,'c'
jz key_is_c
cmp al,'d'
jz key_is_d
cmp al,'e'
jz key_is_e
cmp al,'f'
jz key_is_f

jmp check_other_operations

key_is_0:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],0
jmp hexplore_input_end

key_is_1:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],1
jmp hexplore_input_end

key_is_2:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],2
jmp hexplore_input_end

key_is_3:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],3
jmp hexplore_input_end

key_is_4:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],4
jmp hexplore_input_end

key_is_5:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],5
jmp hexplore_input_end

key_is_6:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],6
jmp hexplore_input_end

key_is_7:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],7
jmp hexplore_input_end

key_is_8:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],8
jmp hexplore_input_end

key_is_9:
shl byte[ebx],4    ;left shift the current selection by 4 bits
add byte[ebx],9        ;or the al value to it
jmp hexplore_input_end

key_is_a:
shl byte[ebx],4
add byte[ebx],0xa
jmp hexplore_input_end

key_is_b:
shl byte[ebx],4
add byte[ebx],0xb
jmp hexplore_input_end

key_is_c:
shl byte[ebx],4
add byte[ebx],0xc
jmp hexplore_input_end

key_is_d:
shl byte[ebx],4
add byte[ebx],0xd
jmp hexplore_input_end

key_is_e:
shl byte[ebx],4
add byte[ebx],0xe
jmp hexplore_input_end

key_is_f:
shl byte[ebx],4
add byte[ebx],0xf
jmp hexplore_input_end


check_other_operations:

cmp al,'+'
jz current_index_increment
cmp al,'-'
jz current_index_decrement

cmp al,0x1B ;escape character. This is a multi byte key.
jz special_keys

jmp hexplore_input_end ;jump to end of this function if none of these comparisons were equal

current_index_increment:
inc byte[ebx]
jmp hexplore_input_end

current_index_decrement:
dec byte[ebx]
jmp hexplore_input_end


special_keys:

;mov [RAM],al
call getchar
;mov [RAM+1],al
call getchar
;mov [RAM+2],al

cmp al,0x35
jz key_page_up
cmp al,0x36
jz key_page_down

cmp al,0x41
jz key_up
cmp al,0x42
jz key_down
cmp al,0x43
jz key_right
cmp al,0x44
jz key_left

jmp hexplore_input_end

key_page_up:
cmp [RAM_address],0
jz  page_up_illegal    ;if zero address, we can't go to negative addresses!
call file_save_page     ;save this page back to file
sub [RAM_address],0x100 ;subtract address to get previous page

call file_load_page

page_up_illegal:
jmp hexplore_input_end

key_page_down:
call file_save_page     ;save this page back to file
add [RAM_address],0x100 ;add address to get next page
call file_load_page
jmp hexplore_input_end

key_up:
mov eax,[RAM_y_select]
cmp eax,0
jz reset_y_15
dec eax
mov [RAM_y_select],eax
jmp hexplore_input_end
reset_y_15:
mov eax,15
mov [RAM_y_select],eax
jmp hexplore_input_end

key_down:
mov eax,[RAM_y_select]
cmp eax,15
jz reset_y_0
inc eax
mov [RAM_y_select],eax
jmp hexplore_input_end
reset_y_0:
mov eax,0
mov [RAM_y_select],eax
jmp hexplore_input_end

key_right:
mov eax,[RAM_x_select]
cmp eax,15
jz reset_x_0
inc eax
mov [RAM_x_select],eax
jmp hexplore_input_end
reset_x_0:
mov eax,0
mov [RAM_x_select],eax
jmp hexplore_input_end

key_left:
mov eax,[RAM_x_select]
cmp eax,0
jz reset_x_15
dec eax
mov [RAM_x_select],eax
jmp hexplore_input_end
reset_x_15:
mov eax,15
mov [RAM_x_select],eax
jmp hexplore_input_end


hexplore_input_end: ;the end label for this function
ret













file_load_page:
;seek to new address in the file
mov edx,0             ;whence argument (SEEK_SET)
mov ecx,[RAM_address] ;move the file cursor to this address
mov ebx,[RAM_filedesc]    ;move the opened file descriptor into EBX
mov eax,19            ;invoke SYS_LSEEK (kernel opcode 19)
int 80h               ;call the kernel

;now that the address has moved, we must read them into the current page of 256 bytes
mov edx,0x100          ;number of bytes to read
mov ecx,RAM            ;address to store the bytes
mov ebx,[RAM_filedesc] ;move the opened file descriptor into EBX
mov eax,3              ;invoke SYS_READ (kernel opcode 3)
int 80h                ;call the kernel
mov [bytes_read],eax

mov ebx,RAM ;make sure ebx points to location after last byte read
add ebx,eax
RAM_fill_page:
cmp eax,0x100      ;if eax(number of bytes read) is 0x100, then the whole page was filled with data
jz RAM_page_filled
;otherwise
mov [ebx],byte '?' ;fill this byte with placeholder unknown value
inc ebx ;go to next byte that needs filling
inc eax
jmp RAM_fill_page
RAM_page_filled:

ret

;function to save current page back to file before switching to new page or ending program

file_save_page:
;seek to new address in the file
mov edx,0             ;whence argument (SEEK_SET)
mov ecx,[RAM_address] ;move the file cursor to this address
mov ebx,[RAM_filedesc]    ;move the opened file descriptor into EBX
mov eax,19            ;invoke SYS_LSEEK (kernel opcode 19)
int 80h               ;call the kernel

mov eax,4          ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,[RAM_filedesc] ;write to the file (not STDOUT)
mov ecx,RAM          ;pointer to RAM to be written to file
mov edx,[bytes_read] ;write the same number of bytes as were loaded to this page before
int 80h             ;system call to write the message

ret
