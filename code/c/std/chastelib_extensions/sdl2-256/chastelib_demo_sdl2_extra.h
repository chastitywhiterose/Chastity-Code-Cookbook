/*28 There is neither Jew nor Greek, there is neither slave nor free, there is neither male nor female—for all of you are one in Christ Jesus. 29 And if you belong to Christ, then you are Abraham’s descendants, heirs according to the promise.*/

int demo_galatians()
{
  sdl_clear();  /*clear the screen before we begin writing*/

  cursor_left=main_font.char_scale*8;

  main_font.char_scale=8; 


  putstr("\nGalatians Chapter 3\n\n");

  main_font.char_scale=4; 

  putstr("28 There is neither Jew nor Greek, there is neither slave nor free, there is neither male nor female-for all of you are one in Christ Jesus.\n\n");
  putstr("29 And if you belong to Christ, then you are Abraham's descendants, heirs according to the promise.\n");

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/

 return 0;
}


int demo_power2()
{
 int a=0,b=0x80;
 int x,y;
 #define length 1000
 int length2=40;
 char c[length];
 
 /*first, display the intro to the demo video*/
  sdl_clear();  /*clear the screen before we begin writing*/

  cursor_left=128;

  main_font.char_scale=8; 

  putstr("\n\nPowers of 2\n\n");

  main_font.char_scale=4; 

  putstr("An SDL2 animation made in the\n\nC Programming Language\n\nby Chastity White Rose\n");

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/
 
 radix=10; /*set the radix we will use*/
 
 main_font.char_scale=3; /*set the font size for animation*/
 cursor_left=0; /*reset the left side position to 0*/

 sdl_putchar=sdl_putchar_slow; /*use the slow drawing function*/
 sdl_clear();  /*clear the screen before we begin writing*/

 x=0;
 while(x<length)
 {
  c[x]=0;
  x++;
 }
 c[0]=1;

 while(a<=b)
 {
  

  x=length2;
  while(x>0)
  {
   x--;
   putint(c[x]);
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
   c[x]+=c[x];
   c[x]+=y;
   if(c[x]>9){y=1;c[x]-=10;}else{y=0;}
   x++;
  }
  if(c[length2]>0){length2++;}

  a++;
 }

 SDL_UpdateWindowSurface(window); /*update window to show the results*/
 sdl_wait_escape(); /*wait till escape key pressed*/

 return 0;
}



int demo_primes()
{
 int x,y,key;
 
 int prime_length=1<<8;
 char *c=malloc(prime_length*sizeof(*c));
 
  /*first, display the intro to the demo video*/
  sdl_clear();  /*clear the screen before we begin writing*/

  cursor_left=192;
  cursor_top=32;
 
  putstr("\n\nPrime Sieve\n\n");

  main_font.char_scale=4; 

  putstr("An SDL2 animation made in the\n\nC Programming Language\n\nby Chastity White Rose\n");

  SDL_UpdateWindowSurface(window); /*update window to show the results*/
  sdl_wait_escape(); /*wait till escape key pressed*/
 
 radix=10;
 int_width=5;
 
 sdl_putchar=sdl_putchar_slow; /*use the slow drawing function*/
 
 putstr=sdl_putstring_wrapped;
 
 main_font.char_scale=20; /*set the font size for animation*/
 sdl_clear();  /*clear the screen before we begin writing*/

 fps=60; /*frames per second*/
 
 loop=1;

 x=0;
 while(x<prime_length)
 {
  c[x]=0;
  x++;
 }
 c[0]=1;

 putint(2);
 putstr(" ");
 x=3;
 while(x<prime_length&&loop)
 {
  putint(x);
  putstr(" ");
  y=x;
  while(y<prime_length)
  {
   c[y]=1;
   y+=x;
  }
  while(x<prime_length && c[x]>0){x+=2;}
  
  
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
    }
   }
  }
  
 }
 
 free(c);
 
 SDL_UpdateWindowSurface(window); /*update window to show the results*/
 sdl_wait_escape(); /*wait till escape key pressed*/
 
 return 0;
}





/*global palette of colors for my demo functions to use*/
 int palette[]={0xFF0000,0xFFFF00,0x00FF00,0x00FFFF,0x0000FF,0xFF00FF};
 int colors=sizeof(palette)/sizeof(*palette);

int sdl_chastelib_test_suite()
{
 /*variables required by SDL*/
 int loop=1;
 int key=1;
 SDL_Event e;

 int a=0,b,c,d; /*variables for this test program*/

 line_spacing_pixels=1; /*empty space in pixels between lines*/
 
 main_font.color=0x00FF00; /*change text color*/

 radix=16;
 int_width=1;

 /*
  I use strint to set the variables by strings rather than immediate values directly
  Doing it this way looks silly, but it is for the purpose of testing the strint function
 */
 b=strint("10"); /*will always be radix*/
 c=b; /*save what the radix was at the beginning. This will be used later.*/
 d=strint("100"); /*will always be radix squared*/
 
 /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  /*start of game loop*/



 if(key) /*start of update on input section*/
 {
  
  sdl_clear();  /*clear the screen before we begin writing*/

  main_font.char_scale=3;
  main_font.color=0xFFFFFF;
  putstr("Official test suite for the C version of chastelib.\nThis version uses SDL2.\n\n");

  main_font.char_scale=4; 

  /*the actual loop that shows the data for 16 numbers at a time*/
  a=b-c;
  while(a<b)
  {
   main_font.color=palette[a%colors];
   radix=2;
   int_width=8;
   putint(a);
   putstr(" ");
   radix=16;
   int_width=2;
   putint(a);
   putstr(" ");
   radix=10;
   int_width=3;
   putint(a);

   if(a>=0x20 && a<=0x7E)
   {
    putstr(" ");
    putchar(a);
    sdl_putchar(a);
   }

   putstr("\n");
   a+=1;
  }

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
 
  /*putint(sizeof(palette)/sizeof(*palette));*/

 
 return 0;
}


