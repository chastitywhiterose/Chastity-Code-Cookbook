int sdl_chastelib_clickulator()
{
 /*variables required by SDL*/
 int loop=1;
 int key=1;
 int change=1;
 SDL_Event e;
 SDL_Rect rect;

 int n=0; /*variables for this test program*/

 line_spacing_pixels=1; /*empty space in pixels between lines*/
 
 main_font.color=0x00FF00; /*change text color*/

 radix=10;
 int_width=1;

 /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  /*start of game loop*/

 rect.x=100;
 rect.y=100;
 rect.w=100;
 rect.h=100;


 if(change) /*start of update on input section*/
 {
  
  sdl_clear();  /*clear the screen before we begin writing*/

  printf("Updating screen\n");

  main_font.char_scale=3;
  main_font.color=0xFFFFFF;
  putstr("Official test suite for the C version of chastelib.\nThis version uses SDL2.\n\n");

  main_font.char_scale=4; 


  SDL_UpdateWindowSurface(window); /*update window to show the results*/
 
} /*end of update on input section*/

 change=0; /*changes are complete zero until next event*/
 key=0; /*key of zero means no input right now*/

  /*loop to capture and process input that happens*/
  while(SDL_PollEvent(&e))
  {

   if(e.type==SDL_MOUSEBUTTONDOWN)
   {
    printf("button.x==%d,button.y==%d\n",e.button.x,e.button.y);
    
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