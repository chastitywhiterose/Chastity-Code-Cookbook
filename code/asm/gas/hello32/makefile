main-gas:
	gcc -nostdlib -nostartfiles -nodefaultlibs -static main.s -o main -m32
	./main
dump:
	objdump -D main > objdump.txt

