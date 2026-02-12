#include <stdio.h>
#include <SDL.h>
int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;
SDL_Rect rect;

#include "sdl_chaste_checkerboard_surface.h"

/*time related variables*/
int sdl_time,sdl_time1,delay,fps=60,frame=0;

int main(int argc, char **argv)
{
 int x=1,y=1,speed=1;
 int colors[]={0x000000,0xFFFFFF};

 if(SDL_Init(SDL_INIT_VIDEO))
 {
  printf( "SDL could not initialize! SDL_Error: %s\n",SDL_GetError());return -1;
 }
 window=SDL_CreateWindow("SDL Program",SDL_WINDOWPOS_CENTERED,SDL_WINDOWPOS_CENTERED,width,height,SDL_WINDOW_SHOWN );
 if(window==NULL){printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );return -1;}
 surface = SDL_GetWindowSurface( window ); /*get surface for this window*/

 printf("SDL Program Compiled Correctly\n");

 /*checkerboard intialization section*/

  init_checkerboard();
  main_check.rectcolor=colors[1];

  main_check.rectsize=90;

  main_check.x_begin=0;
  main_check.y_begin=0;
  /*main_check.x_end=width/2;*/
  /*main_check.y_end=height/2;*/

 /*end of checkerboard intialization section*/

 delay=1000/fps;

 /*start of animation loop*/
 while(loop)
 {

  /*drawing section begin*/

  SDL_FillRect(surface,NULL,colors[0]);
  chaste_checker();

  /*modification of coordinates begins*/

  main_check.x_begin+=x*speed;
  main_check.y_begin+=y*speed;

  /*modification of coordinates ends*/


 /* bounds checking for animation*/

 if(main_check.x_begin>0)
 {
  main_check.x_begin-=main_check.rectsize*2;
 }

 if(main_check.x_begin<-main_check.rectsize*2)
 {
  main_check.x_begin+=main_check.rectsize*2;
 }

 if(main_check.y_begin>0)
 {
  main_check.y_begin-=main_check.rectsize*2;
 }

 if(main_check.y_begin<-main_check.rectsize*2)
 {
  main_check.y_begin+=main_check.rectsize*2;
 }

 /*end of bounds checking*/
  
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
   int k;
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}

    /*https://github.com/libsdl-org/SDL/blob/SDL2/include/SDL_keycode.h*/

    /*user input section start*/

    k=e.key.keysym.sym;

    /*rook directions: orthagonal*/
    if(k==SDLK_KP_8||k==SDLK_UP||k==SDLK_w){x=0;y=-1;}
    if(k==SDLK_KP_2||k==SDLK_DOWN||k==SDLK_x){x=0;y=1;}
    if(k==SDLK_KP_4||k==SDLK_LEFT||k==SDLK_a){x=-1;y=0;}
    if(k==SDLK_KP_6||k==SDLK_RIGHT||k==SDLK_d){x=1;y=0;}

    /*bishop directions: diagonal*/
    if(k==SDLK_KP_1||k==SDLK_z){x=-1;y=1;}
    if(k==SDLK_KP_3||k==SDLK_c){x=1;y=1;}
    if(k==SDLK_KP_7||k==SDLK_q){x=-1;y=-1;}
    if(k==SDLK_KP_9||k==SDLK_e){x=1;y=-1;}

    /*stop moving entirely*/
    if(k==SDLK_KP_5||k==SDLK_s){x=0;y=0;}

    /*press t to reset to 0,0 for starting position of the checkerboard and stop all movement*/
    if(k==SDLK_t){x=0;y=0;  main_check.x_begin=0;main_check.y_begin=0;}

    /*press f to move faster*/
    if(k==SDLK_f){speed++;}
    /*press r to reset speed*/
    if(k==SDLK_r){speed=1;}

    /*user input section end*/

   }
  }

 }
 /*end of loop after user presses escape*/
 
 SDL_DestroyWindow(window);
 SDL_Quit();
 return 0;
}
