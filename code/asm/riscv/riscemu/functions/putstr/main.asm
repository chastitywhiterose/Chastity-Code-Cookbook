# Chastity's putstr function for RISC-V Assembly in riscemu

.data

string0: .asciiz "I am Chastity White Rose\n"

.text

addi s0, zero, string0
jal putstr

addi    a0, zero, 0     # a0=0  (exit code for OS)
addi    a7, zero, 93    # a7=93 (exit system call)
ecall                   #       (environment call)

###############################################################################
# This putstr function is the most portable function for RISC-V simulators #
# It calculates the length of a zero terminated string before printing it     #
# This is the same way used in my Intel Assembly programs for DOS and Linux   #
# This function was written to operate the same in both RARS and riscemu      #
###############################################################################

putstr:

mv t1, s0 # t1 will be used as an index register

putstr_strlen_start:
lb t0, 0(t1)                       # load byte into t0 from address of t1
beq t0, zero, putstr_strlen_end # if t0==0, then we jump to the end of the loop.
addi t1, t1, 1                     # go to next byte
j putstr_strlen_start           # jump to start of the loop
putstr_strlen_end:              


addi a0, zero, 1  # a0=1     (STDOUT file number)
addi a1, s0, 0    # a1=s0    (address of string )
sub  a2, t1, s0   # a2=t1-s0 (length of string  )
addi a7, zero, 64 # a7=64    (write system call )
ecall             #          (environment call  )

ret
