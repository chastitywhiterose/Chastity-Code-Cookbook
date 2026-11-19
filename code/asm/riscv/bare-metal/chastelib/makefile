main-riscv:
	riscv64-unknown-elf-as -march=rv64im -mabi=lp64 main.s -o main.o
	riscv64-unknown-elf-ld -Ttext=0x80000000 main.o -o main.elf
boot:
	echo booting QEMU: press Ctrl+A then X to escape emulator
	qemu-system-riscv64 -machine virt -bios none -nographic -kernel main.elf
disasm:
	riscv64-unknown-elf-objdump -D main.elf

