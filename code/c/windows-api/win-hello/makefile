main-strict:
	gcc -Wall -ansi -pedantic windows-main.c -o windows-main && ./windows-main
main-strip:
	gcc -Wall -ansi -pedantic windows-main.c -o windows-main -s
main-simple:
	gcc windows-main.c -o windows-main && ./windows-main
main-tcc:
	tcc windows-main.c -o windows-main && ./windows-main
main-zig:
	zig cc -Wall -ansi -pedantic windows-main.c -o windows-main && ./windows-main