.section .text
.global _start

_start:
    # Load the memory-mapped UART address (0x10000000)
    li t0, 0x10000000

    # Load address of the message string
    la t1, msg

print_loop:
    lbu t2, 0(t1)          # Load unsigned byte from string
    beqz t2, halt          # If null terminator (0), jump to halt
    sb t2, 0(t0)           # Write byte to UART transmitter register
    addi t1, t1, 1         # Advance string pointer
    j print_loop           # Repeat

halt:
    wfi                    # Wait for interrupt (low-power idle)
    j halt                 # Infinite loop

.section .rodata
msg:
    .asciz "Hello, Bare-Metal RISC-V!\n"
