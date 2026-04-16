main-nasm:
	nasm ELF-32-hello.asm
	chmod +x ELF-32-hello
	./ELF-32-hello
ndisasm:
	ndisasm -b 32 -o 0x8048054 -e 0x54 ELF-32-hello
