main-nasm:
	nasm -f elf64 main.asm
	ld -m elf_x86_64 main.o -o main
	./main
main-yasm:
	yasm -f elf64 main.asm
	ld -m elf_x86_64 main.o -o main
	./main

