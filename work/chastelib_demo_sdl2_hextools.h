/* chastelib_demo_sdl2_hextools.h */

char RAM[0x10000];
int RAM_address_base=0;
int RAM_address_current=0;

int RAM_x=0;
int RAM_y=0;

/*outputs the ASCII text to the right of the hex field*/
void RAM_textdump()
{
 int a,x=0,count=16;

 x=0;
 while(x<count)
 {
  a=RAM[RAM_address_current+x];
  if( a < 0x20 || a > 0x7E )
  {
   sdl_putchar('.');
  }
  else
  {
   sdl_putchar(a);
  }
  x++;
 }

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
  putint(RAM_address_current);
  putstr(" ");

  int_width=2;
  x=0;
  while(x<count)
  {
   putint(RAM[RAM_address_current+x]&0xFF);
   putstr(" ");
   x++;
  }
  RAM_textdump();
  putstr("\n");

  RAM_address_current+=count;
  y++;
 }
 
}







int sdl_chastelib_hexram_edit(int argc, char **argv)
{
 /*variables required by SDL*/
 int loop=1;
 int key=1;
 SDL_Event e;

 int x,y; /*variables for this test program*/

 line_spacing_pixels=1; /*empty space in pixels between lines*/
 
 main_font.color=0xFFFFFF; /*change text color*/
 main_font.char_scale=2;

 radix=16;
 int_width=1;
 
 /*to make for a good test, fill the first page of RAM with all values*/
 x=0;
 y=0x100;
 while(x<y)
 {
  RAM[x]=x;
  x++;
 }
  /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  /*start of game loop*/

 if(key) /*start of update on input section*/
 {
  
  sdl_clear();  /*clear the screen before we begin writing*/



  RAM_hexdump();
  
  putstr("This is the HexRAM demo\nIt displays bytes at a predefined location in RAM\n\n");
  putstr("\nUnlike chastehex and hexplore, the bytes cannot be modified in this demo\n");
  putstr("You can also segfault if you scroll too far!\n\n");
  
  /*this section displays the index variables for indexing the RAM of the current page*/
  putstr("X=");
  putint(RAM_x);
  putstr(" Y=");
  putint(RAM_y);
  putstr("\n");

/*
 update the cursor position (in pixels) so that we can print brackets around the byte that is selected
 the math is done in two steps for each coordinate for simplification
*/

cursor_x=8*main_font.char_width*main_font.char_scale; /*navigate past the address field*/
cursor_x+=RAM_x*3*main_font.char_width*main_font.char_scale; /*find the right byte to bracket*/

cursor_y=RAM_y*main_font.char_height*main_font.char_scale; /*find the right row*/
cursor_y+=RAM_y*line_spacing_pixels; /*adjust for the line spacing used by my library*/

sdl_putchar('[');
cursor_x+=2*main_font.char_width*main_font.char_scale; /*go forward 3 characters*/
sdl_putchar(']');

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
    /*
     if a key has been pressed, we copy the global variables of the RAM selected
     into these temporary variables mostly just to save code space by referring to variables
     of a single letter name
    */
    int x=RAM_x;
    int y=RAM_y;
   
    key=e.key.keysym.sym;
    switch(key)
    {
     /*use q as a key that can also end this loop*/
     case SDLK_q:
      loop=0;
     break;
   
    /*the main 4 directions*/
    case SDLK_UP:
     y--;if(y<0){y=15;}
    break;
    case SDLK_DOWN:
     y++;if(y>=16){y=0;}
    break;
    case SDLK_LEFT:
     x--;if(x<0){x=15;}
    break;
    case SDLK_RIGHT:
     x++;if(x>=16){x=0;}
    break;
     
     case SDLK_PAGEUP:
      RAM_address_base-=0x100;
     break;
     case SDLK_PAGEDOWN:
      RAM_address_base+=0x100;
     break;
     
    }

    /*set the global x and y index variables from the local copies*/
    RAM_x=x;
    RAM_y=y;
   } /*end of SDL_KEYDOWN section*/


  }

  /*end of game loop*/
 }
 

 
 return 0;
}
