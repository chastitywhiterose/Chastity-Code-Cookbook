; hello-world.asm
; print "hello world" to stdout and exit

.data

msg:    .asciiz "Hello world\n"

string0: .asciiz "I am Chastity White Rose"

        .text
        addi    a0, zero, 1             ; print to stdout
        addi    a1, zero, string0           ; load msg address
        addi    a2, zero, 12            ; write 12 bytes
        addi    a7, zero, SCALL_WRITE   ; write syscall code
       ; scall



	addi s0, zero, string0
jal putstring



        addi    a0, zero, 0             ; set exit code to 0
        addi    a7, zero, SCALL_EXIT    ; exit syscall code
        scall


; The putstring function should be called after the s0 register contains the address of the string to print.
; It performs some math to find the length of the string, assuming the final byte is a zero.

putstring:

;li a7,4      # load immediate, v0 = 4 (4 is print string system call)
;mv a0,s0  # load address of string to print into a0

mv t1, s0 ; t1 will be used as an index register

putstring_strlen_start:
lb t0, 0(t1) ; load byte into t0 from address of t1
beq t0, zero, putstring_strlen_end ; if t0==0, then we jump to the end of the loop.
addi t1, zero, 1
;jal zero, putstring_strlen_start
putstring_strlen_end:

;cmp [ebx],byte 0 ; compare byte at address ebx with 0
;jz putstring_strlen_end ; if comparison was zero, jump to loop end because we have found the length
;inc ebx
;jmp putstring_strlen_start

addi    a0, zero, 1  ;STDOUT file number
addi    a1, s0, 0

addi    a7, zero, 64 ;SCALL_WRITE number


scall
ret

