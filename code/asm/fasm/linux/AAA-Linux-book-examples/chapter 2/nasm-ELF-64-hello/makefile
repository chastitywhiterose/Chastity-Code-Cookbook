main-nasm:
	nasm ELF-64-hello.asm
	chmod +x ELF-64-hello
	./ELF-64-hello
ndisasm:
	ndisasm -b 64 -o 0x400078 -e 0x78 ELF-64-hello
