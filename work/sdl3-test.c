#include <stdio.h>
#include <SDL.h>
int width=1280,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;
int main(int argc, char **argv)
{
 if(!SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",width,height,0);
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/
 SDL_FillSurfaceRect(surface,NULL,0xFF00FF);
 SDL_UpdateWindowSurface(window);
 printf("SDL Program Compiled Correctly\n");
 while(loop)
 {
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_EVENT_QUIT){loop=0;}
   if(e.type == SDL_EVENT_KEY_UP)
   {
    if(e.key.key==SDLK_ESCAPE){loop=0;}
   }
  }
 }
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}

/*
 This source file is an example to be included in Chastity's Code Cookbook. By following the migration guide, I converted the SDL2-test program to the changes in SDL3.

 https://wiki.libsdl.org/SDL3/README-migration

 Windows Compile Command:

 gcc -Wall -ansi -pedantic sdl3-test.c -o sdl3-test -IC:/w64devkit/include/SDL3 -lSDL3 && sdl3-test

 Linux Compile Command: (this is not fully tested yet)

 With the sdl2-config script:
 gcc -Wall -ansi -pedantic sdl3-test.c -o sdl3-test `sdl3-config --cflags --libs` && ./sdl3-test

 Without the sdl2-config script:
 gcc -Wall -ansi -pedantic sdl3-test.c -o sdl3-test -I/usr/include/SDL3 -lSDL3 && ./sdl3-test

*/
