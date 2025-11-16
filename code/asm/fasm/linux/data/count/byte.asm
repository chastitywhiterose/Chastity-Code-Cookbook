; example of declaring bytes of data in a fasm source file
; run with: fasm bytes.asm && hexdump -C bytes.bin

a=0
while a<256
db a
a=a+1
end while