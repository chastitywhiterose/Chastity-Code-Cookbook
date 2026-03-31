/*
 main.c source file for an SDL2 project by Chastity White Rose
*/
#include <stdio.h>
#include <stdlib.h>
#include <SDL.h>
#include "chastelib.h"

int width=1280,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;

/*
This header file must be included after the above global variables
because it depends on them.
*/
#include "chastelib_font_sdl.h"

int main(int argc, char **argv)
{
 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL2 Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/
 SDL_FillRect(surface,NULL,0xFF00FF);
 SDL_UpdateWindowSurface(window);
 printf("SDL Program Compiled Correctly\n");
 
 /*load the font from a file*/
 main_font=chaste_font_load("./font/FreeBASIC Font 8.bmp");
 
 /*change the scale of each character*/
 main_font.char_scale=4; 
 
 putstr=sdl_putstring; /*change the putstr function to the SDL version*/

 /*clear the screen before we begin writing*/
 sdl_clear();
 
 putstr("This program is an alpha demo of translating my chastelib text functions to use the SDL library.\n");
 
  /*update window to show the results*/
  SDL_UpdateWindowSurface(window);
 
 /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }
  }
 }
 
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}

/*
 This source file is an example to be included in Chastity's Code Cookbook. This example follows the SDL version 2 which works differently than the most up to date version (version 3 at this time). There is also an updated version in the same repository that works with version 3.

 Linux Compile Command:

 With the sdl2-config script:
 gcc -Wall -ansi -pedantic sdl2-test.c -o sdl2-test `sdl2-config --cflags --libs` && ./sdl2-test

 Without the sdl2-config script:
 gcc -Wall -ansi -pedantic sdl2-test.c -o sdl2-test -I/usr/include/SDL2 -lSDL2 && ./sdl2-test
*/
