org 100h

main:

mov ah,40h         ;select DOS function 40h write 
mov bx,1           ;file handle 1=stdout
mov cx,13          ;number of bytes to write including 0Ah (line feed)
mov dx,main_string ;dx will have address of string to write
int 21h            ;call the DOS kernel to complete the write

mov ax,4C00h       ;function to end the program
int 21h            ;call the DOS kernel to exit the program

main_string db 'Hello World!', 0Ah 
