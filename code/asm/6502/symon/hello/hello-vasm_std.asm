# 6502 Assembly source for assembler Vasm
# This uses the standard syntax for Vasm.
# Comments begin with #
# hexadecimal numbers begin with 0x rather than $
# Assembler directives begin with a dot (.)


# The program runs in the symon simulator for 6502 which was written in java
# Output the string 'Hello, World!' repeatedly



.equ iobase,0x8800
.equ iostatus , iobase + 1
.equ iocmd    , iobase + 2
.equ ioctrl   , iobase + 3

.org 0x300

main:   cli
        lda #0x0b
        sta iocmd
        lda #0x1a
        sta ioctrl

init:   ldx #0x00

loop:   lda iostatus
        and #0x10
        beq loop
        lda string,x
        beq init
        sta iobase

        inx
        jmp loop       ; Repeat write.

string: .byte "Hello, 6502 world! ", 0
