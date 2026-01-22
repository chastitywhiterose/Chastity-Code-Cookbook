char RAM[0x10000];
int RAM_address=0;
int RAM_view_x=0;
int RAM_view_y=2;

int byte_selected_x=0;
int byte_selected_y=0;

/*
this function is really the entire game. It calls other functions as needed to render everything.
*/
void hexplore()
{

 int scale=8;
 int text_x=width*1/6;

 delay=1000/fps;

 loop=1;
 while(loop)
 {
  sdl_time = SDL_GetTicks();
  sdl_time1 = sdl_time+delay;

  SDL_SetRenderDrawColor(renderer,0,0,0,255);
  SDL_RenderClear(renderer);

  main_color=0x00FFFF;
  scale=16;
  lgbt_draw_text("LGBT",text_x,main_lgbt.height*1*scale,scale);

  main_color=0xFFFF00;
  scale=8;
  lgbt_draw_text("Light\nGraphics\nBinary\nText",text_x,main_lgbt.height*5*scale,scale);

  main_color=0xFF00FF;
  lgbt_draw_text("This text was drawn with a program written by Chastity White Rose\nSimilar methods were used in her games:\nChaste Tris, Chaste Puyo, and Chaste Panel",16,main_lgbt.height*10*scale,2);
 
  SDL_RenderPresent(renderer);

  /*time loop used to slow the game down so users can see it*/
  while(sdl_time<sdl_time1)
  {
   sdl_time=SDL_GetTicks();
  }

  /*test for events and only process if they exist*/
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }
  }
  
 }

}
