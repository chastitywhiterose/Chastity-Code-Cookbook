main-riscv:
	riscv64-unknown-elf-as -march=rv64i -mabi=lp64 hello.s -o hello.o
	riscv64-unknown-elf-ld -T linker.ld hello.o -o hello.elf
boot:
	qemu-system-riscv64 -machine virt -bios none -nographic -kernel hello.elf

