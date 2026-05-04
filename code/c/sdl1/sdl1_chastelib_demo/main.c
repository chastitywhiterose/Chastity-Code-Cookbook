/*
 main.c source file for an SDL1 project by Chastity White Rose
 SDL1 is the legacy version of SDL and only done for entertainment.
*/
#include <stdio.h>
#include <stdlib.h>
#include <SDL.h>
#include "chastelib.h"

int width=1280,height=720;
int loop=1;
SDL_Surface *surface;
SDL_Event e;

/*
This header file must be included after the above global variables
because it depends on them.
*/

#include "chastelib_format_pbm_sdl1.h"
#include "chastelib_font_sdl1.h"
#include "chastelib_demo_sdl1.h"

int main(int argc, char **argv)
{
 int x; /*variable to use for whatever I feel like*/

 if(SDL_Init(SDL_INIT_EVERYTHING)){return 1;}

 SDL_putenv("SDL_VIDEO_WINDOW_POS=center");
 SDL_WM_SetCaption("SDL1 Program",NULL);
 surface=SDL_SetVideoMode(width,height,32,SDL_SWSURFACE);
 if(surface==NULL){return 1;}

 SDL_FillRect(surface,NULL,0xFF00FF);

 SDL_Flip(surface); /*update window to show the results*/
 printf("SDL Program Compiled Correctly\n");
 
 /*load the font from a BMP file using the old method*/
 /*main_font=chaste_font_load("./font/FreeBASIC Font 8.bmp");*/

 /*load the font from the PBM file with my custom function in chastelib_format_pbm.h*/
 main_font=chaste_font_load_pbm("./font/font8.pbm");
 
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
  SDL_Flip(surface); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/
 }

 /*now call a demo function I wrote*/
 sdl_chastelib_test_suite();

 if(0)
 {
  sdl_clear();  /*clear the screen before we begin writing*/
  putstr("This program has ended\nPress Esc to close this window.\n");
  SDL_Flip(surface); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/
 }
 
 SDL_Quit();
 return 0;
}

/*
 This source file is an example to be included in the Chastity's Code Cookbook repository.
 This example follows the SDL version 1 which is old and hard to find help on.
 The following is the source I used when translating from version 2 to 1.

 https://www.libsdl.org/release/SDL-1.2.15/docs/

main-sdl2:
	gcc -Wall -ansi -pedantic main.c -o main `sdl2-config --cflags --libs` -lm && ./main

*/

