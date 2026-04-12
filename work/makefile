main-elf:
	gcc -Wall -ansi -pedantic celf64.c -o celf64 && ./celf64
	chastehex fasmelf64
	#chastecmp fasmelf64 casmelf64
	chastehex casmelf64
	chmod +x casmelf64
	#./casmelf64
fasm:
	fasm fasmelf64.asm
	chastehex fasmelf64
	chmod +x fasmelf64
	./fasmelf64
main-strict:
	gcc -Wall -ansi -pedantic main.c -o main && ./main
ndisasm:
	ndisasm -b 64 -o 0x400078 -e 0x78 fasmelf64
compare:
	chastecmp fasmelf64 casmelf64

