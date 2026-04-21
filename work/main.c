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

#include "chastelib_format_pbm_sdl2.h"
#include "chastelib_font_sdl2.h"
#include "chastelib_demo_sdl2.h"
#include "chastelib_demo_sdl2_extra.h"
#include "chastelib_demo_sdl2_hextools.h"

int main(int argc, char **argv)
{
 int x; /*variable to use for whatever I feel like*/

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
 
 /*load the font from a BMP file using the old method*/
 main_font=chaste_font_load("./font/FreeBASIC Font 8.bmp");

 /*load the font from the PBM file with my custom function in chastelib_format_pbm.h*/
 /*main_font=chaste_font_load_pbm("./font/font8.pbm");*/
 
 /*change the scale of each character*/
 main_font.char_scale=4; 
 
 /*change the putstr function to the SDL version*/
 putstr=sdl_putstring;
 
 /*or use the version that automatically wraps words of text*/
 putstr=sdl_putstring_wrapped;

 /*
 below is an eight line test program to check if everything is correct!
 */

 if(0)
 {
  sdl_clear();  /*clear the screen before we begin writing*/
  x=putstr("Hello World\n"); /*draw a string of text to the surface*/
  putstr("string length = ");
  radix=10;
  putint(x);
  putstr("\nPress Esc to continue.\n");
  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/
 }
 
  /*demo_galatians();*/

 /*now call a demo function I wrote*/
 /*sdl_chastelib_test_suite();*/
 
 sdl_chastelib_hexram(argc,argv); /*call this function and pass the command args to it*/


 if(0)
 {
  sdl_clear();  /*clear the screen before we begin writing*/
  putstr("This program has ended\nPress Esc to close this window.\n");
  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/
 }
 
 SDL_FreeSurface(main_font.surface); 
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}

/*
 This source file is an example to be included in the Chastity's Code Cookbook repository.
 This example follows the SDL version 2 which works differently than
 the most up to date version (version 3 at this time).

main-sdl2:
	gcc -Wall -ansi -pedantic main.c -o main `sdl2-config --cflags --libs` -lm && ./main

*/

