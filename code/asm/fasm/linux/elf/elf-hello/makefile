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