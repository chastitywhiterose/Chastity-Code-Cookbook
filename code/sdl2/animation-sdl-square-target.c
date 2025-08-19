#include <stdio.h>
#include <SDL.h>
int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;

/*time related variables*/
int sdl_time,sdl_time1,delay,fps=60,frame=0;

int main(int argc, char **argv)
{
 int x,y;
 int colors[]={0x000000,0xFFFFFF},index=0,index1=0;
 int rect_width=30,rect_height=30;
 SDL_Rect rect;
 int bitcount;

 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/

 printf("SDL Program Compiled Correctly\n");

 delay=1000/fps;
 bitcount=0;
 index1=0;

 /*start of animation loop*/
 while(loop)
 {

  /*drawing section begin*/

  rect.w=width;
  rect.h=height;

  x=0;
  y=0;

  index=index1;
  SDL_FillRect(surface,NULL,colors[index^1]);

  while(rect.w>0)
  {
   rect.x=x+bitcount;
   rect.y=y+bitcount;
   rect.w=width-x*2-bitcount*2;
   rect.h=height-y*2-bitcount*2;
   SDL_FillRect(surface,&rect,colors[index]);
   x+=rect_width;
   y+=rect_height;
   index^=1;
  }

  if(bitcount==rect_width)
  {
   bitcount=0;
   index1^=1;
  }
  bitcount++;

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
