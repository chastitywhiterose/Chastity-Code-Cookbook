dim shared as integer rect_size=32;

/'
 this function draws a checkerboard. it is highly optimized because it does not switch colors during the function. it only draws half of the checkerboard squares and leaves the remaining areas the same as the background
'/
sub chaste_checker()
 dim as integer x,y,index,index1,rect_x,rect_y
 
 index=0
 rect_x=0
 rect_y=0

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

end sub