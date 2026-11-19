# Bare Metal RISC-V Assembly

I have used RISC-V programming in the RARS simulator before, and even written my chastelib functions for it. However, I became curious about how to do bare metal programming for a RISC-V machine bootloader with no operating system.

Fortunately, it isn't that difficult to achieve. I found a source file and some commands that can assembly and run the file using the RISC-V version of QEMU.

This file contains all the relevant source and commands, though I do not understand the options of them them yet.

## hello.s

```
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
```

## linker.ld

```
OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
    . = 0x80000000;
    .text : {
        *(.text*)
    }
    .rodata : {
        *(.rodata*)
    }
    .data : {
        *(.data*)
    }
    .bss : {
        *(.bss*)
    }
}
```

## Assembling the source

```
riscv64-unknown-elf-as -march=rv64i -mabi=lp64 hello.s -o hello.o
riscv64-unknown-elf-ld -T linker.ld hello.o -o hello.elf
```

## Running the program in QEMU

```
qemu-system-riscv64 -machine virt -bios none -nographic -kernel hello.elf
```

## Essential Keyboard Shortcuts

Because -nographic routes standard Ctrl+C signals directly to the guest OS instead of closing QEMU, you must use QEMU's escape sequence (Ctrl+a, then release both keys and press the second key) to control the emulator:

- Ctrl+a then x. Immediately terminates the QEMU process and returns you to your host shell.
- Ctrl+a then c. Toggles input focus between the guest's serial console and the QEMU monitor prompt.
- Ctrl+a then h. Prints the full list of available multiplexer escape commands in your terminal.


## Other Links

<https://www.vociferousvoid.org/index.php/2019/11/01/risc-v-bare-metal-programming-chapter-1-the-setup/>