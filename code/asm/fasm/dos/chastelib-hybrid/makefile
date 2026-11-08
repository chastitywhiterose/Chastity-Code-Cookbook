main-fasm-dos:
	fasm main.asm
main-nasm-dos:
	chastext main.asm 'include' '%include' > temp.asm
	nasm temp.asm -o main.com
main-fasm-linux:
	fasm main.asm
	chmod +x main
	./main
ndisasm:
	ndisasm -o 0x100 main.com
