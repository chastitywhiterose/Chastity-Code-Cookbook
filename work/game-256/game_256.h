void game()
{
 int loop=1,key=0;
 SDL_Rect player_rect;
 
 int player_x_move=0;
 int player_y_move=0;
 
 player_rect.x=100;
 player_rect.y=100;
 player_rect.w=64;
 player_rect.h=64;

radix=10;
 
  /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  SDL_FillRect(surface,NULL,0x000000);

  /*do not allow to go below screen*/
  if(player_rect.y+player_rect.h>=height)
  {
   putstr("player_rect.y==");
   putint(player_rect.y);
   putstr("\n");

   player_rect.y=height-player_rect.h-1;
   player_y_move=0;
  }

  /*update player x and/or y position based on movement variables*/
  player_rect.x+=player_x_move;
  player_rect.y+=player_y_move;
  
  SDL_FillRect(surface,&player_rect,0xFF00FF); /*draw the player*/
   
  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  
  /*loop to capture and process input that happens*/
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}

   /*use Escape as a key that can also end this loop*/
   if(e.type == SDL_KEYUP)
   {
    putstr("SDL_KEYUP\n");
    key=e.key.keysym.sym;
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
    
    switch(key)
    {
     /*the main 4 directions*/
     case SDLK_UP:
      player_y_move=0;
     break;
     case SDLK_DOWN:
      player_y_move=0;
     break;
     case SDLK_LEFT:
      player_x_move=0;
     break;
     case SDLK_RIGHT:
      player_x_move=0;
     break;
    }
   }

   if(e.type == SDL_KEYDOWN && e.key.repeat==0)
   {
    putstr("SDL_KEYDOWN\n");
    key=e.key.keysym.sym;
    switch(key)
    {
     /*use q as a key that can also end this loop*/
     case SDLK_q:
      loop=0;
     break;
   
     /*the main 4 directions*/
     case SDLK_UP:
      player_y_move=-1;
     break;
     case SDLK_DOWN:
      player_y_move=1;
     break;
     case SDLK_LEFT:
      player_x_move=-1;
     break;
     case SDLK_RIGHT:
      player_x_move=1;
     break;
    }
   }

 
  }
  
 } /*end of game while loop*/
 
} /*end of game function*/
