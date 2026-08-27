int game_title()
{
 
 /*first, display the intro to the demo video*/
  sdl_clear();  /*clear the screen before we begin writing*/

  cursor_left=128;

  main_font.char_scale=8; 

  putstr("\n\nDeath Box\n\n");

  main_font.char_scale=4; 

  putstr("An SDL2 game made in the\nC Programming Language\nby Chastity White Rose\n\n");
  putstr("You are a magenta box\nThe green boxes will kill you.\n");
  
  putstr("Move with the arrow keys.\n");
  putstr("Press Esc to start the game.\n");

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/
  
  return 0;
 }



/*
a global character pointer
this will be filled with a power of two in decimal
*/
char *p=NULL;
int pi=0; /*pointer index to level data*/
int pim=0; /*pointer_index_max*/

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

 while(a<b)
 {
 

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
 
   /*print the final power of two after the loop is done*/
  x=length2;
  while(x>0)
  {
   x--;
   printf("%d",p[x]);
  }
  
 /*optionally, print which power of two was printed this line*/
  putstr(" = ");
  putstr("2^");
  putint(a);

  putstr("\n");

  pim=length2;
  printf("pim==%d\n",pim);
  pi=pim;

 
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
int game()
{
 int x,y;
 int loop=1,key=0;
 int frame=0; /*frame counter*/
 int fps=360; /*frames per second*/
 int fpb=500; /*frames per deathbox*/
 int sdl_time,sdl_time1; /*define the timing integers*/
 int delay=1000/fps;

 /*
 there will be a maximum of ten death boxes on the screen at one time
 the size of each box will be the height of the screen divided by ten
 */
 SDL_Rect deathbox[10];

 SDL_Rect player_rect;
 
 int player_x_move=0;
 int player_y_move=0;
 
 player_rect.x=width/2;
 player_rect.y=height/2;
 player_rect.w=32;
 player_rect.h=32;
 
 load_power2(1<<10);



 x=0;
 y=10;

 while(x<y)
 {
  deathbox[x].x=0;
  deathbox[x].y=0;
  deathbox[x].w=height/10;
  deathbox[x].h=height/10;
  x++;
 }
 

 radix=10;
 
  /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  sdl_time = SDL_GetTicks(); /*get the current time in milliseconds*/
  sdl_time1 = sdl_time+delay; /*make copy of time with delay added*/

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

  /*cursor_x=10;
  cursor_y=10;
  putint(frame);
  putstr("\n");*/
  frame++;

  if(frame%fpb==0) /*create a deathbox every so many frames*/
  {
  
   


   /*find the first available box which has a rectange x value of 0 or less*/
   x=0;
   while(x<y)
   {
    if(deathbox[x].x==0) /*if the x of this box is 0*/
    {
     deathbox[x].x=width; /*set to width so it shows up on the right*/
     pi--; /*subtract 1 from pointer for array boundaries*/
     deathbox[x].y=height-((p[pi]+1)*deathbox[x].h); /*set box y based on box height and next digit of power of two*/
     /*printf("this digit==%d\n",p[pi]);*/
     if(pi==0){pi=pim;} /*if index 0 already reached, reset to pointer index max*/
     break; /*break from the loop now that this box is created*/
    }
    
    if(fpb>100) /*if frames per box is above this value*/
    {
     fpb--; /*subtract from this to make boxes appear faster over time*/
     printf("fpb==%d\n",fpb);
    }
    else /*otherwise changes frame speed for boxes and the player!*/
    {
     fps++; /*increase the frame per second instead*/
     printf("fps==%d\n",fps);
     delay=1000/fps; /*recalculate the delay for the slowdown routine*/
    }
   
    x++;
   }

  }

   /*but every frame we must process the boxes and draw them if valid*/
   x=0;
   while(x<y)
   {
    if(deathbox[x].x!=0) /*if this box is not x of 0*/
    {
     SDL_FillRect(surface,&deathbox[x],0x00FF00); /*draw the deathbox*/
     deathbox[x].x-=1; /*otherwise subtract 1 to move left*/
    }
    x++;
   }
   
  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  
  /*after we have displayed the game screen, we need to end if the player touches any blocks*/
   x=0;
   while(x<y)
   {
    if(SDL_HasIntersection(&player_rect, &deathbox[x]))
    {
     printf("Player touched deathbox[%d]\n",x);
     printf("at location %d,%d\n",deathbox[x].x,deathbox[x].y);
     loop=0;
     break;
    }
    x++;
   }

  /*time loop used to slow the game down so users can see it*/
  while(sdl_time<sdl_time1)
  {
   sdl_time=SDL_GetTicks();
  }
  
  /*loop to capture and process input that happens*/
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}

   /*use Escape as a key that can also end this loop*/
   if(e.type == SDL_KEYUP)
   {
    /*putstr("SDL_KEYUP==");*/
    key=e.key.keysym.sym;
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
    
    switch(key)
    {
     /*the main 4 directions*/
     case SDLK_UP:
     case SDLK_w:
      /*putstr("SDLK_UP\n");*/
      player_y_move=0;
     break;
     case SDLK_DOWN:
     case SDLK_s:
      /*putstr("SDLK_DOWN\n");*/
      player_y_move=0;
     break;
     case SDLK_LEFT:
     case SDLK_a:
      /*putstr("SDLK_LEFT\n");*/
      player_x_move=0;
     break;
     case SDLK_RIGHT:
     case SDLK_d:
      /*putstr("SDLK_RIGHT\n");*/
      player_x_move=0;
     break;
    }
   }

   if(e.type == SDL_KEYDOWN && e.key.repeat==0)
   {
    /*putstr("SDL_KEYDOWN==");*/
    key=e.key.keysym.sym;
    switch(key)
    {
     /*use q as a key that can also end this loop*/
     case SDLK_q:
      loop=0;
     break;
   
     /*the main 4 directions*/
     case SDLK_UP:
     case SDLK_w:
      /*putstr("SDLK_UP\n");*/
      player_y_move=-1;
     break;
     case SDLK_DOWN:
     case SDLK_s:
      /*putstr("SDLK_DOWN\n");*/
      player_y_move=1;
     break;
     case SDLK_LEFT:
     case SDLK_a:
      /*putstr("SDLK_LEFT\n");*/
      player_x_move=-1;
     break;
     case SDLK_RIGHT:
     case SDLK_d:
      /*putstr("SDLK_RIGHT\n");*/
      player_x_move=1;
     break;
    }
   }

 
  }
  
 } /*end of game while loop*/
 
 return 0;
} /*end of game function*/



int game_end(int x)
{
 
 /*first, display the intro to the demo video*/
  sdl_clear();  /*clear the screen before we begin writing*/

  cursor_left=128;

  main_font.char_scale=8; 

  putstr("\n\nGame Over\n\n");

  main_font.char_scale=4; 

  putstr("Player touched deathbox!");
  
  putstr("You have died, but don't feel bad\nThis game just gets faster until you eventually lose.");
  
   putstr("Press Esc to close the game.\n");

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/
  
  return 0;
 }
