main-sdl3:
	gcc -Wall -ansi -pedantic main.c -o main -I/usr/include/SDL3 -lSDL3 && ./main
main-sdl2:
	gcc -Wall -ansi -pedantic main.c -o main `sdl2-config --cflags --libs` -lm && ./main
main-sdl1:
	gcc -Wall -ansi -pedantic main.c -o main `sdl-config --cflags --libs` && ./main
main-strict:
	gcc -Wall -ansi -pedantic main.c -o main && ./main
main-simple:
	gcc main.c -o main && ./main
