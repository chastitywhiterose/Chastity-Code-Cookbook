/*
sdl_chaste_checkerboard_surface.h

This file contains my functions for drawing a checkerboard in SDL2 using software surfaces.
*/

struct checkerboard
{
 int x_begin,y_begin,x_end,y_end;
 int rectsize;
 int rectcolor;
};

struct checkerboard main_check;

/*set up initial state to allow drawing checkerboard to whole screen*/
void init_checkerboard()
{
 main_check.x_begin=0;
 main_check.y_begin=0;
 main_check.x_end=width;
 main_check.y_end=height;
 main_check.rectsize=32;
 main_check.rectcolor=0xFFFFFF;
}

/*
 this function draws a checkerboard. it is highly optimized because it does not switch colors during the function. it only draws half of the checkerboard squares and leaves the remaining areas the same as the background
*/
void chaste_checker()
{
 int x,y,index,index1;
 index=0;

 rect.w=main_check.rectsize;
 rect.h=main_check.rectsize;

 y=main_check.y_begin;
 while(y<main_check.y_end)
 {
  index1=index;
  x=main_check.x_begin;
  while(x<main_check.x_end)
  {
   if(index==1)
   {
    rect.x=x;
    rect.y=y;
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

/*
 this function draws a checkerboard on top of an existing surface. It is a copy of the original with modifciations for direct pixel access. This kind of pixel access is one of the main reasons I use SDL surfaces.
*/
void chaste_checker_xor()
{
 int tx,ty,tx2,ty2; /*temp variables only for drawing the square*/
 Uint32 *dsp; /*dsp is short for Destination Surface Pointer*/

 int x,y,index,index1;
 index=0;

 dsp=(Uint32*)surface->pixels;

 rect.w=main_check.rectsize;
 rect.h=main_check.rectsize;

 y=main_check.y_begin;
 while(y<main_check.y_end)
 {
  index1=index;
  x=main_check.x_begin;
  while(x<main_check.x_end)
  {
   if(index==1)
   {
    rect.x=x;
    rect.y=y;

    /*SDL_RenderFillRect(renderer,&rect);*/
    /*SDL_FillRect(surface,&rect,main_check.rectcolor);*/

    /*set up the temporary coordinate variables*/
    tx2=rect.x+rect.w;
    ty2=rect.y+rect.h;

    if(rect.x<0){/*printf("Error: Negative X\n");*/ /*return;*/ rect.x=0;}
    if(rect.y<0){/*printf("Error: Negative Y\n");*/ /*return;*/ rect.y=0;}

    if(tx2>=width){/*printf("Error: X too high.\n");*/ /*return;*/ tx2=width;}
    if(ty2>=height){/*printf("Error: Y too high.\n");*/ /*return;*/ ty2=height;}

    /*draw square with direct pixel access*/
      ty=rect.y;
      while(ty<ty2)
      {
       tx=rect.x;
       while(tx<tx2)
       {
        dsp[tx+ty*width]^=main_check.rectcolor;
        tx++;
       }
       ty++;
      }

   }
   index^=1;

   x+=main_check.rectsize;
  }
  index=index1^1;
  y+=main_check.rectsize;
 }

}






















