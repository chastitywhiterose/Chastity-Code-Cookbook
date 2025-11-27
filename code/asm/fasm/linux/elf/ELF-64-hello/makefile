main-fasm:
	fasm ELF-64-hello.asm
	chmod +x ELF-64-hello.bin
	./ELF-64-hello.bin
chastehex-compare:
	chastehex main && chastehex ELF-64-hello.bin
chastecmp-compare:
	chastecmp main ELF-64-hello.bin
ndisasm:
	ndisasm -b 64 -o 0x400078 -e 0x78 ELF-64-hello.bin