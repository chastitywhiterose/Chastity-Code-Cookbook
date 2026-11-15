;the next function which pushes ax to the stack
;moves the address of the line string and prints it with putstring
;then it pops the original value of ax back from the stack before the function returns
;this allows me to print a newline anywhere in the code without a single register changing

line db 0Dh,0Ah,0 ;a string containing only a newline

putline:
push ax
mov ax,line
call putstring
pop ax
ret