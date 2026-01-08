#include <stdio.h>
#include <SDL.h>
int width=1280,height=720;
int loop=1;
SDL_Surface *surface;
SDL_Event e;
int main(int argc, char **argv)
{
 if(SDL_Init(SDL_INIT_EVERYTHING)){return 1;}

 SDL_putenv("SDL_VIDEO_WINDOW_POS=center");
 SDL_WM_SetCaption("SDL1 Program",NULL);
 surface=SDL_SetVideoMode(width,height,32,SDL_SWSURFACE);
 if(surface==NULL){return 1;}

 SDL_FillRect(surface,NULL,0xFF00FF);

 while(loop)
 {
  while(SDL_PollEvent(&e))
  {
   if(e.type==SDL_QUIT){loop=0;}
   if(e.type==SDL_KEYUP){if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}}
  }
  SDL_Flip(surface);
 }

 SDL_Quit();
 return 0;    
}

/*
SDL1 program that creates a window but nothing else.
Closes when user presses Esc or clicks the X of the window.
This is to test whether SDL1 programs can be compiled.

 With the sdl-config script:
 gcc -Wall -ansi -pedantic sdl1-test.c -o sdl1-test `sdl-config --cflags --libs` && ./sdl1-test

 Without the sdl-config script:
 gcc -Wall -ansi -pedantic sdl1-test.c -o sdl1-test -I/usr/include/SDL -D_GNU_SOURCE=1 -L/usr/lib/x86_64-linux-gnu -lSDL && ./sdl1-test
*/
