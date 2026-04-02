/* chastelib_demo_sdl.h */

int sdl_chastelib_test_suite()
{
 /*variables required by SDL*/
 int loop=1;
 int key=0;
 SDL_Event e;

 int a=0,b,c,d; /*variables for this test program*/

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



  /*loop to capture and process input that happens*/
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}

   /*use Escape as a key that can also end this loop*/
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }

   if(e.type == SDL_KEYDOWN && e.key.repeat==0)
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

 /*start of update on input section*/

 sdl_clear();  /*clear the screen before we begin writing*/
 putstring("\x1B[2J"); /*clear the terminal with an escape sequence*/
 putstring("\x1B[H"); /*reset terminal cursor to home*/

 main_font.char_scale=3; 
 putstr("Official test suite for the C version of chastelib.\n\n");

 /*the actual loop that shows the data for 16 numbers at a time*/
 a=b-c;
 while(a<b)
 {
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
  }

  putstr("\n");
  a+=1;
 }

 SDL_UpdateWindowSurface(window); /*update window to show the results*/
 /*end of update on input section*/

    
   } /*end of SDL_KEYDOWN section*/


  }

  /*end of game loop*/
 }
 
 return 0;
}
