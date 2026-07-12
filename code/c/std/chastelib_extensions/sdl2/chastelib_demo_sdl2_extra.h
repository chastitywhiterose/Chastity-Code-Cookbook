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

