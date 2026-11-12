fasm:
	fasm main.asm
nasm:
	chastext main.asm 'include' '%include' > temp.asm
	nasm temp.asm -o main.com
hex:
	chastehex main.com
ndisasm:
	ndisasm -o 0x100 main.com

