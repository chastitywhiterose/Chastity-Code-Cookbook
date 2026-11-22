riscv64-unknown-elf-as -march=rv32imac -mabi=ilp32 main.s -o main.o
riscv64-unknown-elf-ld -melf32lriscv -Ttext=0x80000000 main.o -o main.elf
echo booting QEMU: press Ctrl+A then X to escape emulator
qemu-system-riscv32 -machine virt -bios none -nographic -kernel main.elf
