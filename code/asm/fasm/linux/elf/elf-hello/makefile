main-fasm:
	cat elf-hello.asm
	fasm elf-hello.asm
	chastehex elf-hello
	chmod +x elf-hello
	./elf-hello
reserve:
	cat elf-hello-reserve.asm
	fasm elf-hello-reserve.asm
	chastehex elf-hello-reserve
	chmod +x elf-hello-reserve
	./elf-hello-reserve
compare:
	chastecmp elf-hello elf-hello-reserve
ndisasm:
	ndisasm -b 32 -o 0x8048054 -e 0x54 elf-hello

