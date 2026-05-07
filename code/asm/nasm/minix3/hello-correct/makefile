main-nasm-minix:
	nasm -f elf main.asm -o main.o
	ld -m elf_i386_minix main.o -o main
main-nasm-linux:
	nasm -f elf32 main.asm
	ld -m elf_i386 main.o -o main
	./main
main-yasm-linux:
	nasm -f elf32 main.asm
	ld -m elf_i386 main.o -o main
	./main
dump:
	objdump -D main.o > objdump.txt
