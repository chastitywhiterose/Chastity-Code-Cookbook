/*
This is an SDL program meant to use my LGBT library for drawing text
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <SDL.h>

/*
most variables in the program are global. Unless I create temporary variables in other functions.
*/
int width=1280,height=720;
int loop=1;
int Window_Flags=0;
SDL_Window *window = NULL;
/*SDL_Surface *surface;*/
SDL_Renderer *renderer = NULL;
SDL_Event e;
SDL_Rect rect;

int rect_color;

int frame=0,lastframe=0,fps=60,delay,framelimit=1; /*only used for animation demos*/
time_t time0,time1;
int seconds,minutes,hours; /*to keep track of time*/
int sdl_time,sdl_time1;

#include "sdl_lgbt_format-lite.h"

int main(int argc, char **argv)
{
 if(SDL_Init(SDL_INIT_VIDEO)){printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;}
 window=SDL_CreateWindow( "LGBT",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,Window_Flags);
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}

 renderer = SDL_CreateRenderer(window,-1,0);
 if(renderer==NULL){printf( "Renderer could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 
 main_lgbt=lgbt_load_bmp("./font/FreeBASIC Font 8.bmp");
 
 /*
  Notice: At this point the font is loaded and the main program can begin. I just want to take a moment to say that setting up
  even a minor application in SDL takes several steps. We must have a window, a game loop, and a means of getting input from the user
  Because of this, once I create the window and load the font, I like to put the entire application in another function that is called from main.
  This means that theoretically, multiple programs can be loaded from the foundation already created from the main.c source file.
  Although most don't need to know this, I write to myself to remind myself what the hell I am doing in my programming.
 */



 lgbt_demo();

 SDL_DestroyRenderer(renderer);
 SDL_DestroyWindow(window);
 SDL_Quit();

 return 0;
}

