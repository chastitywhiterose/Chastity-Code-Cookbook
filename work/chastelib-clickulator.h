int sdl_chastelib_clickulator()
{
 /*variables required by SDL*/
 int loop=1;
 int key=1;
 int change=1;
 SDL_Event e;
 SDL_Rect rect;   /*used for temporary rectangle construction and detection*/
 SDL_Point mouse; /*used to store coordinates of mouse clicks*/

 /*upper left coordinates of where calculator buttons start*/
 int button_area_x=200; 
 int button_area_y=150;
 int button_size=90;

 unsigned int n=0; /*variables for this test program*/

 line_spacing_pixels=1; /*empty space in pixels between lines*/
 
 main_font.color=0x00FF00; /*change text color*/

 radix=2;
 int_width=32;

 /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  /*start of game loop*/

 if(change) /*start of update on input section*/
 {
  /*clear the screen before we redraw*/
  SDL_FillRect(surface,NULL,0x000000);

  /*cursor_x=cursor_left;cursor_y=cursor_top;*/

  cursor_x=cursor_left+main_font.char_width*8;
  cursor_y=cursor_top+main_font.char_width*4;
  main_font.char_scale=8;
  main_font.color=0xFFFFFF;
  putstr("SDL2 clickulator\n");

  /*button 0*/
  rect.x=button_area_x+button_size*1;
  rect.y=button_area_y+button_size*0;
  rect.w=button_size;
  rect.h=button_size;
  SDL_FillRect(surface,&rect,0x808080);
  cursor_x=rect.x+1;
  cursor_y=rect.y+1;
  main_font.char_scale=11;
  sdl_putchar_blit('0');
  
  if(SDL_PointInRect(&mouse,&rect))
  {
   printf("Button Zero Pressed\n");
   printf("mouse.x==%d,mouse.y==%d\n",mouse.x,mouse.y);
   n<<=1;
  }

  /*button 1*/
  rect.x=button_area_x+button_size*2;
  rect.y=button_area_y+button_size*0;
  rect.w=button_size;
  rect.h=button_size;
  SDL_FillRect(surface,&rect,0x808080);
  cursor_x=rect.x+1;
  cursor_y=rect.y+1;
  main_font.char_scale=11;
  sdl_putchar_blit('1');
  
  if(SDL_PointInRect(&mouse,&rect))
  {
   printf("Button One Pressed\n");
   printf("mouse.x==%d,mouse.y==%d\n",mouse.x,mouse.y);
   n<<=1;
   n+=1;
  }

  /*button backspace*/
  rect.x=button_area_x+button_size*4;
  rect.y=button_area_y+button_size*0;
  rect.w=button_size*4;
  rect.h=button_size;
  SDL_FillRect(surface,&rect,0x808080);
  /*draw smaller rectangle inside to delete space*/
  rect.x=rect.x+1;
  rect.y=rect.y+1;
  rect.w=rect.w-2;
  rect.h=rect.h-2;
  SDL_FillRect(surface,&rect,0x000000);

  cursor_x=rect.x+1;
  cursor_y=rect.y+1;
  main_font.char_scale=11;
  sdl_putstring("back\n");

  if(SDL_PointInRect(&mouse,&rect))
  {
   printf("Button Backspace Pressed\n");
   printf("mouse.x==%d,mouse.y==%d\n",mouse.x,mouse.y);
   n>>=1;
  }

  /*print the integer*/
  main_font.char_scale=4;
  cursor_x=100;
  cursor_y=360;
  putint(n);
  putstr("\n");

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
 
} /*end of update on input section*/

 change=0; /*changes are complete zero until next event*/
 key=0; /*key of zero means no input right now*/

  /*loop to capture and process input that happens*/
  while(SDL_PollEvent(&e))
  {

   if(e.type==SDL_MOUSEBUTTONDOWN)
   {
    mouse.x=e.button.x;
    mouse.y=e.button.y;
    printf("mouse.x==%d,mouse.y==%d\n",mouse.x,mouse.y);
    change=1; /*signal that something has changed*/
 
    /*   
    if (e.button.button == SDL_BUTTON_LEFT)
    {
     printf("Left Click!\n");
    }
    else if (e.button.button == SDL_BUTTON_RIGHT)
    {
     printf("Right Click!\n");
    }
    else if(e.button.button == SDL_BUTTON_MIDDLE)
    {
     printf("Middle Click!\n");
    }
   */
   }


   if(e.type == SDL_QUIT){loop=0;}

   /*use Escape as a key that can also end this loop*/
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }

   if(e.type == SDL_KEYDOWN /*&& e.key.repeat==0*/)
   {
    key=e.key.keysym.sym;
    switch(key)
    {
     /*use q as a key that can also end this loop*/
     case SDLK_q:
      loop=0;
     break;  
    }



    
   } /*end of SDL_KEYDOWN section*/


  }

  /*end of game loop*/
 }
 
  /*putint(sizeof(palette)/sizeof(*palette));*/

 
 return 0;
}
