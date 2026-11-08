;The function below is putstring for DOS
;It works using interrupt 0x21 under FreeDOS or DOSBox.

putstring:

push ax
push bx
push cx
push dx

mov bx,ax                  ;copy ax to bx to be used as index to the string

putstring_strlen_start:    ;this loop finds the length of the string as part of the putstring function

cmp byte[bx],0             ;compare this byte with 0
jz putstring_strlen_end    ;if comparison was zero, jump to loop end because we have found the length
inc bx
jmp putstring_strlen_start ;jump to the start of the loop and keep trying until we find a zero

putstring_strlen_end:
sub bx,ax                  ; sub ax from bx to get the difference for number of bytes

;Write string using DOS Write system call.
;write(int fd, const void buf[.count], size_t count);
;ax=0x40,bx=fd,dx=buf,cx=count

mov cx,bx        ;number of bytes to write
mov dx,ax        ;pointer/address of string to write
mov bx,1         ;write to the STDOUT file
mov ah,0x40      ;write (kernel opcode 0x40 on 16 bit DOS)
int 21h          ;system call for 16-bit DOS kernel

pop dx
pop cx
pop bx
pop ax

ret ;this is the end of the putstring function return to calling location
