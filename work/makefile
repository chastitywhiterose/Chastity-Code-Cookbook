main-elf:
	gcc -Wall -ansi -pedantic celf64.c -o celf64 && ./celf64
	chastehex casmelf64
	chmod +x casmelf64
	./casmelf64
fasm:
	fasm fasmelf64.asm
	chastehex fasmelf64
	chmod +x fasmelf64
	./fasmelf64
main-strict:
	gcc -Wall -ansi -pedantic main.c -o main && ./main
ndisasm:
	ndisasm -b 32 -o 0x8048054 -e 0x54 casmelf64
compare:
	chastecmp fasmelf64 casmelf64

