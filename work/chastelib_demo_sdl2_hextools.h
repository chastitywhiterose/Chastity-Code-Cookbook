/* chastelib_demo_sdl2_hextools.h */

char RAM[0x10000];
int RAM_address_base=0;
int RAM_address_current=0;

/*outputs the ASCII text to the right of the hex field*/
void RAM_textdump()
{
 int a,x=0;

/*
 x=count;
 while(x<0x10)
 {
  putstring("   ");
  x++;
 }
 */

 x=0;
 while(x<count)
 {
  a=RAM[RAM_address_current+x];
  if( a < 0x20 || a > 0x7E ){a='.';bytes[x]=a;}
  x++;
 }
 bytes[x]=0;

 putstring(bytes);
}


/*outputs up 16 bytes on each row in hexadecimal at the RAM location*/
void RAM_hexdump()
{
 int x,y,count=16;
 
 RAM_address_current=RAM_address_base;
 
 y=0;
 while(y<count)
 {
  int_width=8;
  putint(address);
  putstr(" ");

  int_width=2;
  x=0;
  while(x<count)
  {
   putint(RAM[RAM_address_current+x]);
   putstr(" ");
   x++;
  }
  RAM_textdump();
  putstr("\n");

  address+=count;
  y++;
 }
 
}

int sdl_chastelib_hexram(int argc, char **argv)
{
 /*variables required by SDL*/
 int loop=1;
 int key=1;
 SDL_Event e;

 int a=0,b,c,d; /*variables for this test program*/

 line_spacing_pixels=1; /*empty space in pixels between lines*/
 
 main_font.color=0xFFFFFF; /*change text color*/
 main_font.char_scale=2;

 radix=16;
 int_width=1;
 
 RAM[0]=5;

  /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  /*start of game loop*/

 if(key) /*start of update on input section*/
 {
  
  sdl_clear();  /*clear the screen before we begin writing*/

  putstr("Official test suite for the C version of chastelib.\nThis version uses SDL2.\n\n");

 

  RAM_hexdump();

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
 
} /*end of update on input section*/

 key=0; /*key of zero means no input right now*/

  /*loop to capture and process input that happens*/
  while(SDL_PollEvent(&e))
  {
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
   
     /*the main 4 directions*/
     case SDLK_UP:
      if(b>c){b--;}
     break;
     case SDLK_DOWN:
      if(b<d){b++;}
     break;
     case SDLK_LEFT:
      if(b>=c+c){b-=c;}
     break;
     case SDLK_RIGHT:
      if(b<=d-c){b+=c;}
     break;
    }



    
   } /*end of SDL_KEYDOWN section*/


  }

  /*end of game loop*/
 }
 

 
 return 0;
}
