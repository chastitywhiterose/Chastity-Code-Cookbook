#include <stdio.h>
#include <SDL.h>

int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;

SDL_Renderer *renderer = NULL;
#include "sdl_chaste_polygon.h"

/*time related variables*/
int sdl_time,sdl_time1,delay,fps=60,frame=0;

int main(int argc, char **argv)
{
 int x,y;
 int colors[]={0x000000,0xFFFFFF},index=0,color;
 int radius_change=30;

 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/

 /*create a renderer that can draw to the surface*/
 renderer=SDL_CreateSoftwareRenderer(surface);
 if(renderer==NULL){printf("Renderer could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}

 printf("SDL Program Compiled Correctly\n");

 delay=1000/fps;

/*
  an optional step before the game loop but a very awesome one
  initialize the spinning polygon that will be drawn each frame
 */

 init_polygon();
 main_polygon.radius=height/2;
 main_polygon.sides=3;
 main_polygon.step=1;

 main_polygon.cx=width/2;
 main_polygon.cy=height/2;

 x=0;

 /*start of animation loop*/
 while(loop)
 {

  /*drawing section begin*/

  SDL_FillRect(surface,NULL,colors[0]);

 index=0;

 y=height/2; /*save initial radius to y variable*/

 main_polygon.radius=y;

 while(main_polygon.radius>0)
 {
  color=colors[index];
  main_polygon.color.r=(color&0xFF0000)>>16;
  main_polygon.color.g=(color&0x00FF00)>>8;
  main_polygon.color.b=(color&0x0000FF);

  /*show the polygon just for fun*/
  chaste_polygon_draw_star();
  y-=radius_change;
  main_polygon.radius=y-x;
 
  index^=1;  
 }
  main_polygon.radians+=PI/180;

  x++;

  if(x==radius_change*2)
  {
   x=0;
  }

  /*drawing section end*/

  SDL_UpdateWindowSurface(window);

  sdl_time = SDL_GetTicks();
  sdl_time1 = sdl_time+delay;

  /*time loop used to slow the game down so users can see it*/
  while(loop==1 && sdl_time<sdl_time1)
  {
   sdl_time=SDL_GetTicks();
  }

  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }
  }

 }
 /*end of loop after user presses escape*/
 
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}
