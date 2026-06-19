;returns in al register a character from the keyboard
getchr:

mov ah,1
int 21h

ret