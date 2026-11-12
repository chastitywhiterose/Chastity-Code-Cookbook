fasm:
	fasm main.asm
nasm:
	chastext main.asm 'include' '%include' > temp.asm
	nasm temp.asm -o main.bin
ndisasm:
	ndisasm -o 0x7C00 main.bin
hex:
	chastehex main.bin
boot:
	qemu-system-i386 -drive file=main.bin,format=raw

