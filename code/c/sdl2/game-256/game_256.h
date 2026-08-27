
/*
a global character pointer
this will be filled with a power of two in decimal
*/
char *p=NULL;

int load_power2(int e)
{
 /*e stands for exponent*/
 int a=0,b=e;
 int x,y;
 int length=e;
 int length2=1;
 
 if(p==NULL){p=malloc(length*sizeof(*p));}
 
 radix=10; /*set the radix we will use*/
 
 x=0;
 while(x<length)
 {
  p[x]=0;
  x++;
 }
 p[0]=1;

 while(a<=b)
 {
  

  x=length2;
  while(x>0)
  {
   x--;
   putint(p[x]);
  }
  
  /*optionally, print which power of two was printed this line*/
  putstr(" = ");
  putstr("2^");
  putint(a);

  putstr("\n");

  y=0;
  x=0;
  while(x<=length2)
  {
   p[x]+=p[x];
   p[x]+=y;
   if(p[x]>9){y=1;p[x]-=10;}else{y=0;}
   x++;
  }
  if(p[length2]>0){length2++;}

  a++;
 }
 
 /*
 below is an example of how to free the memory
 
 but for this game we don't actually free it because it is a global pointer meant to be used
 during the entire duration of the game
 */
 
 /*if(p!=NULL){free(p);}*/ 
 
 return 0;
}



/*
this is the game function.
it handles almost everything except for data which is preloaded
*/
void game()
{
 int loop=1,key=0;
 SDL_Rect player_rect;
 
 int player_x_move=0;
 int player_y_move=0;
 
 player_rect.x=width/2;
 player_rect.y=height/2;
 player_rect.w=64;
 player_rect.h=64;

radix=10;
 
  /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  SDL_FillRect(surface,NULL,0x000000);

  /*do not allow to go above screen*/
  if(player_rect.y<0)
  {
   /*putstr("player_rect.y==");
   putint(player_rect.y);
   putstr("\n");*/
   player_rect.y=0;
   player_y_move=0;
  }

  /*do not allow to go below screen*/
  if(player_rect.y+player_rect.h>=height)
  {
   /*putstr("player_rect.y==");
   putint(player_rect.y);
   putstr("\n");*/
   player_rect.y=height-player_rect.h-1;
   player_y_move=0;
  }

  /*do not allow to go left of screen*/
  if(player_rect.x<0)
  {
   /*putstr("player_rect.x==");
   putint(player_rect.x);
   putstr("\n");*/
   player_rect.x=0;
   player_x_move=0;
  }

  /*do not allow to go right of screen*/
  if(player_rect.x+player_rect.w>=width)
  {
   /*putstr("player_rect.x==");
   putint(player_rect.x);
   putstr("\n");*/
   player_rect.x=width-player_rect.w-1;
   player_x_move=0;
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
    putstr("SDL_KEYUP==");
    key=e.key.keysym.sym;
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
    
    switch(key)
    {
     /*the main 4 directions*/
     case SDLK_UP:
      putstr("SDLK_UP\n");
      player_y_move=0;
     break;
     case SDLK_DOWN:
      putstr("SDLK_DOWN\n");
      player_y_move=0;
     break;
     case SDLK_LEFT:
      putstr("SDLK_LEFT\n");
      player_x_move=0;
     break;
     case SDLK_RIGHT:
      putstr("SDLK_RIGHT\n");
      player_x_move=0;
     break;
    }
   }

   if(e.type == SDL_KEYDOWN && e.key.repeat==0)
   {
    putstr("SDL_KEYDOWN==");
    key=e.key.keysym.sym;
    switch(key)
    {
     /*use q as a key that can also end this loop*/
     case SDLK_q:
      loop=0;
     break;
   
     /*the main 4 directions*/
     case SDLK_UP:
      putstr("SDLK_UP\n");
      player_y_move=-1;
     break;
     case SDLK_DOWN:
      putstr("SDLK_DOWN\n");
      player_y_move=1;
     break;
     case SDLK_LEFT:
      putstr("SDLK_LEFT\n");
      player_x_move=-1;
     break;
     case SDLK_RIGHT:
      putstr("SDLK_RIGHT\n");
      player_x_move=1;
     break;
    }
   }

 
  }
  
 } /*end of game while loop*/
 
} /*end of game function*/
