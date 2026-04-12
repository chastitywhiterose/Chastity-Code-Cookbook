main-elf:
	gcc -Wall -ansi -pedantic celf32.c -o celf32 && ./celf32
	chastehex casmelf32
	chmod +x casmelf32
	./casmelf32
fasm:
	fasm fasmelf32.asm
	chastehex fasmelf32
	chmod +x fasmelf32
	./fasmelf32
main-strict:
	gcc -Wall -ansi -pedantic main.c -o main && ./main
ndisasm:
	ndisasm -b 32 -o 0x8048054 -e 0x54 casmelf32
compare:
	chastecmp fasmelf32 casmelf32

