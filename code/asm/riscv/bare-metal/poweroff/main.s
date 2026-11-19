.section .rodata

string0: .asciz "chastelib putstr for bare metal RISC-V Assembly\n"
string1: .asciz "This program turns off automatically\n"

.section .text
.global _start

_start:

la s0, string0
jal putstr
la s0, string1
jal putstr

#Trigger QEMU poweroff via SiFive Test Finisher
li t0, 0x100000        # Base address of SiFive test device on QEMU virt
li t1, 0x5555          # FINISHER_PASS value (triggers poweroff with exit code 0)
sw t1, 0(t0)           # Write 0x5555 to 0x100000

halt:
wfi                    # Wait for interrupt (low-power idle)
j halt                 # Infinite loop

###############################################################################
# This putstr function is for a RISC-V bootloader while running from QEMU     #
# It uses memory mapped output that is specific to the "-machine virt" option #
# It prints characters from the string address pointed to by the s0 register  #
# It uses the temporary registers t0, t1 and t2 to index all character arrays #
###############################################################################

putstr:

mv t1, s0                     #t1 will be used as an index register
li t2, 0x10000000             #Load the memory-mapped UART address (0x10000000)

putstr_loop_beg:
lb t0, 0(t1)                  #load byte into t0 from address of t1
beq t0, zero, putstr_loop_end #if t0==0, then we jump to the end of the loop.
sb t0, 0(t2)                  #save byte from t0 into address of t1
addi t1, t1, 1                #go to next byte
j putstr_loop_beg             #jump to start of the loop
putstr_loop_end:              

ret
