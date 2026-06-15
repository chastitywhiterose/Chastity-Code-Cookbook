main-fasm:
	fasm main.asm
	chmod +x main
	./main
ndisasm:
	ndisasm -b 64 -o 0x400078 -e 0x78 main
chastecmp:
	fasm main.asm
	chmod +x main
	./main file1.txt file2.txt