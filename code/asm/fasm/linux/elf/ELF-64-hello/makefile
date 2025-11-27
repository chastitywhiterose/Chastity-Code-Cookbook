main-fasm:
	fasm ELF-64-hello.asm
	chmod +x ELF-64-hello.bin
	./ELF-64-hello.bin
chastehex-compare:
	chastehex main && chastehex ELF-64-hello.bin
chastecmp-compare:
	chastecmp main ELF-64-hello.bin
