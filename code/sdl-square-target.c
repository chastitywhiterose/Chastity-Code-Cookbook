#include <stdio.h>
#include <SDL.h>
int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;
int main(int argc, char **argv)
{
 int x,y;
 int colors[]={0x000000,0xFFFFFF},index=0;
 int rect_width=30,rect_height=30;
 SDL_Rect rect;

 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/

 /*drawing section begin*/

 rect.w=width;
 rect.h=height;

 x=0;
 y=0;

 while(rect.w>0)
 {
  rect.x=x;
  rect.y=y;
  SDL_FillRect(surface,&rect,colors[index]);
  x+=rect_width;
  y+=rect_height;
  rect.w-=rect_width*2;
  rect.h-=rect_height*2;
  index^=1;
 }

 /*drawing section end*/

 SDL_UpdateWindowSurface(window);

 printf("SDL Program Compiled Correctly\n");

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
