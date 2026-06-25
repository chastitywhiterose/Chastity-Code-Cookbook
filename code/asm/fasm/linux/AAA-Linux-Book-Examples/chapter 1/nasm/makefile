main-nasm:
	nasm -f elf32 main.asm
	ld -m elf_i386 main.o -o main
	./main
main-yasm:
	nasm -f elf32 main.asm
	ld -m elf_i386 main.o -o main
	./main
dump:
	objdump -D main.o > objdump.txt
dump-intel:
	objdump -D main.o > objdump.txt -M intel
