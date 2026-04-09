main-nasm:
	nasm -f elf main.asm
	ld -m elf_i386 main.o -o main
	./main
dump:
	objdump -D main.o > objdump.txt

