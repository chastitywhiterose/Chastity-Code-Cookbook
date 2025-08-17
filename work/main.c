#include <stdio.h>
#include <SDL.h>
int width=720,height=720;
int loop=1;
SDL_Window *window;
SDL_Surface *surface;
SDL_Event e;
SDL_Rect rect;

#include "sdl_chaste_checkerboard_surface.h"

/*default clip is size of whole window*/
int clip_start_x=0,clip_start_y=0,clip_end_x=720,clip_end_y=720;

void chaste_checker_clip()
{
 int x,y,index,index1;
 index=0;

 y=main_check.y_begin;
 while(y<main_check.y_end)
 {
  index1=index;
  x=main_check.x_begin;
  while(x<main_check.x_end)
  {
   if(index==1)
   {
    int diff;
    rect.x=x;
    rect.y=y;
    rect.w=main_check.rectsize;
    rect.h=main_check.rectsize;

    if(rect.x<clip_start_x){diff=clip_start_x-rect.x;rect.x+=diff;rect.w-=diff;}
    if(rect.y<clip_start_y){diff=clip_start_y-rect.y;rect.y+=diff;rect.h-=diff;}

    if(rect.x+rect.w>clip_end_x){rect.w=clip_end_x-rect.x;}
    if(rect.y+rect.h>clip_end_y){rect.h=clip_end_y-rect.y;}

    /*SDL_RenderFillRect(renderer,&rect);*/
    SDL_FillRect(surface,&rect,main_check.rectcolor);
   }
   index^=1;
   x+=main_check.rectsize;
  }
  index=index1^1;
  y+=main_check.rectsize;
 }

}

/*time related variables*/
int sdl_time,sdl_time1,delay,fps=60,frame=0;

int main(int argc, char **argv)
{
 int x=1,y=1,speed=1;
 int colors[]={0x000000,0xFFFFFF};
 int tx,ty; /*temporary variables*/

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
  main_check.rectsize=30;

  main_check.x_begin=0;
  main_check.y_begin=0;

 /*end of checkerboard intialization section*/

 delay=1000/fps;

 frame=0;

 /*start of animation loop*/
 while(loop)
 {

  /*drawing section begin*/

  SDL_FillRect(surface,NULL,colors[0]);

  /*modification of coordinates begins*/

  main_check.x_begin+=x*speed;
  main_check.y_begin+=y*speed;

  /*modification of coordinates ends*/

  /*save the values to be restored*/
  tx=main_check.x_begin;
  ty=main_check.y_begin;

  /*top left area*/
  clip_start_x=0;
  clip_start_y=0;
  clip_end_x=width/3;
  clip_end_y=height/3;

  main_check.x_begin=tx+clip_start_x;
  main_check.y_begin=ty+clip_start_y;
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();

  /*top center area*/
  clip_start_x=width*1/3;
  clip_start_y=0;
  clip_end_x=width*2/3;
  clip_end_y=height/3;

  main_check.x_begin=clip_start_x;
  main_check.y_begin=ty+clip_start_y;
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();

  /*top right area*/

  clip_start_x=width*2/3;
  clip_start_y=0;
  clip_end_x=width;
  clip_end_y=height*1/3;

  main_check.x_begin=width-(tx+clip_start_x);
  main_check.y_begin=ty+clip_start_y;
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();

  /*bottom left area*/
  clip_start_x=0;
  clip_start_y=height*2/3;
  clip_end_x=width/3;
  clip_end_y=height;

  main_check.x_begin=tx+clip_start_x;
  main_check.y_begin=height-(ty+clip_start_y);
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();

  /*bottom center area*/
  clip_start_x=width*1/3;
  clip_start_y=height*2/3;
  clip_end_x=width*2/3;
  clip_end_y=height;

  main_check.x_begin=clip_start_x;
  main_check.y_begin=height-(ty+clip_start_y);
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();


  /*bottom right area*/
  clip_start_x=width*2/3;
  clip_start_y=height*2/3;
  clip_end_x=width;
  clip_end_y=height;

  main_check.x_begin=width-(tx+clip_start_x);
  main_check.y_begin=height-(ty+clip_start_y);
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();

  /*center center area*/
  clip_start_x=width*1/3;
  clip_start_y=height*1/3;
  clip_end_x=width*2/3;
  clip_end_y=height*2/3;

  main_check.x_begin=/*tx+*/clip_start_x;
  main_check.y_begin=/*ty+*/clip_start_y;
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();

  /*left center area*/
  clip_start_x=width*0/3;
  clip_start_y=height*1/3;
  clip_end_x=width*1/3;
  clip_end_y=height*2/3;

  main_check.x_begin=tx+clip_start_x;
  main_check.y_begin=/*ty+*/clip_start_y;
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();

  /*right center area*/
  clip_start_x=width*2/3;
  clip_start_y=height*1/3;
  clip_end_x=width*3/3;
  clip_end_y=height*2/3;

  main_check.x_begin=width-(tx+clip_start_x);
  main_check.y_begin=/*ty+*/clip_start_y;
  main_check.x_end=clip_end_x;
  main_check.y_end=clip_end_y;

  chaste_checker_clip();


  /*restore the values saved earlier*/
  main_check.x_begin=tx;
  main_check.y_begin=ty;

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



  frame++;
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
