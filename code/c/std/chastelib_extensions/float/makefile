main-strict:
	gcc -Wall -ansi -pedantic main.c -o main -lm && ./main
main-simple:
	gcc main.c -o main -lm && ./main
main-sdl2:
	gcc -Wall -ansi -pedantic main.c -o main `sdl2-config --cflags --libs` -lm && ./main
