riscv64:
	riscv64-unknown-elf-as -march=rv64imac -mabi=lp64 main.s -o main.o
	riscv64-unknown-elf-ld -Ttext=0x80000000 main.o -o main.elf
boot64:
	echo booting QEMU: press Ctrl+A then X to escape emulator
	qemu-system-riscv64 -machine virt -bios none -nographic -kernel main.elf
riscv32:
	riscv64-unknown-elf-as -march=rv32imac -mabi=ilp32 main.s -o main.o
	riscv64-unknown-elf-ld -melf32lriscv -Ttext=0x80000000 main.o -o main.elf
boot32:
	echo booting QEMU: press Ctrl+A then X to escape emulator
	qemu-system-riscv32 -machine virt -bios none -nographic -kernel main.elf
disasm:
	riscv64-unknown-elf-objdump -D main.elf
labels:
	riscv64-unknown-elf-nm main.elf

