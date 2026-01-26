FILE* fp; /*file pointer*/
int file_address=0;
int count=0; /*keeps track of how many bytes were last read from file*/
int eof_char='?'; /*character used by this program to show user the end of file is reached*/

char RAM[0x10000];
int RAM_address=0;
int RAM_view_x=0;
int RAM_view_y=2;

int byte_selected_x=0;
int byte_selected_y=0;


/*outputs the ASCII text to the right of the hex field*/
void std_RAM_textdump(int y,int width)
{
 int a,x=0;
 int count=16;
 x=count;
 while(x<0x10)
 {
  putstring("   ");
  x++;
 }

 x=0;
 while(x<count)
 {
  a=RAM[RAM_address+x+y*width];
  if( a < 0x20 || a > 0x7E ){a='.';}
  putchar(a);
  x++;
 }

}

/*
prints the current page of RAM to the terminal
this lets me know if things are working as expected
*/
void std_RAM_hexdump()
{
 int x,y;
 int width=16,height=16;
 radix=16;
 
 y=0;
 while(y<height)
 {
  int_width=8;
  radix=16;
  putint(RAM_address+y*width);
  putstring(" ");
  int_width=2;
  x=0;
  while(x<width)
  {
   putint(RAM[x+y*width]&0xFF);
   putstring(" ");

   x++;
  }

  std_RAM_textdump(y,width);
  
  putstring("\n");
  y++;
 }

}





/*outputs the ASCII text to the right of the hex field to the buffer*/
void sdl_RAM_textdump(int y,int width)
{
 int a,x=0;
 int count=16;
 x=count;
 while(x<0x10)
 {
  bufcat("   ");
  x++;
 }

 x=0;
 while(x<count)
 {
  a=RAM[RAM_address+x+y*width];
  if( a < 0x20 || a > 0x7E ){a='.';}
  bufchar(a);
  x++;
 }

}




/*
prints the current page of RAM to the buffer
this lets me know if things are working as expected
*/
void sdl_RAM_hexdump()
{
 int x,y;
 int width=16,height=16;
 radix=16;
 
 y=0;
 while(y<height)
 {
  int_width=8;
  radix=16;
  bufcat(intstr(RAM_address+y*width));
  bufcat(" ");
  int_width=2;
  x=0;
  while(x<width)
  {
   bufcat(intstr(RAM[x+y*width]&0xFF));
   bufcat(" ");

   x++;
  }

  sdl_RAM_textdump(y,width);
  
  bufcat("\n");
  y++;
 }

}

 int key=0;

/*this function is an SDL port of the keyboard function from the Raylib version of Chaste Tris*/
void keyboard()
{

 int width=16,height=16;
 int x=byte_selected_x;
 int y=byte_selected_y;

  if( e.type == SDL_QUIT ){loop=0; printf("X clicked! This program will close!\n");}
  if (e.type == SDL_KEYDOWN && e.key.repeat==0)
  {


   key=e.key.keysym.sym;

   switch(key)
   {
    case SDLK_ESCAPE:
     loop=0;
    break;

    case SDLK_q:
     loop=0;
    break;
   
    /*the main 4 directions*/
    case SDLK_UP:
     y--;if(y<0){y=15;}
    break;
    case SDLK_DOWN:
     y++;if(y>=height){y=0;}
    break;
    case SDLK_LEFT:
     x--;if(x<0){x=15;}
    break;
    case SDLK_RIGHT:
     x++;if(x>=width){x=0;}
    break;
    
   
   }

  }

 byte_selected_x=x;
 byte_selected_y=y;
}





/*
this function is really the entire game. It calls other functions as needed to render everything.
*/
void hexplore()
{
 int scale=8;
 int text_x=width*1/6;
 int i; /*used to index the RAM sometimes*/
 
 /*attempt to read 256 bytes for the first page*/
 count=fread(RAM,1,0x100,fp);
 i=count;while(i<0x100){RAM[i]=eof_char;i++;}
 
 std_RAM_hexdump(); /*dump the RAM to terminal once just for testing*/

 delay=1000/fps;
 loop=1;
 while(loop)
 {
  sdl_time = SDL_GetTicks();
  sdl_time1 = sdl_time+delay;

  SDL_SetRenderDrawColor(renderer,0,0,0,255);
  SDL_RenderClear(renderer);
  
  /*print title of program at the top*/
  main_color=0x00FFFF;
  scale=8;
  lgbt_draw_text("Hexplore",text_x,0x10,scale);

  /*print hex dump of current page in real time*/
  main_color=0xFF00FF;
  scale=2;

  sdl_RAM_hexdump(); /*send hexdump to buffer*/
  lgbt_draw_text(buffer,0x10,0x80,scale);
  bp=buffer;
  
 /*RAM[0]++;
  RAM[4]--;*/
 
  /*display the selected byte in green so we can see it*/ 
  main_color=0x00FF00;
  
  bufcat(intstr(RAM[byte_selected_x+byte_selected_y*16]&0xFF));
  lgbt_draw_text(buffer,(0x10+(9*8*scale))+byte_selected_x*3*8*scale,0x80+(byte_selected_y*8*scale),scale);
  bp=buffer;

  bufcat("X=");  
  bufcat(intstr(byte_selected_x));
  bufcat(" Y=");  
  bufcat(intstr(byte_selected_y));
  bufcat(" K=");  
  bufcat(intstr(key));
  lgbt_draw_text(buffer,8*scale,0x60,scale);
  bp=buffer;

  
  /*print information about the program*/
  
  main_color=0xFFFF00;
  scale=2;

  bufcat("This program is the start of a game, but what kind of game?");
  lgbt_draw_text(buffer,0x10,0x190,scale);
  bp=buffer;
  
  
 
  SDL_RenderPresent(renderer);

  /*time loop used to slow the game down so users can see it*/
  while(sdl_time<sdl_time1)
  {
   sdl_time=SDL_GetTicks();
  }

  /*test for events and only process if they exist*/
  while(SDL_PollEvent(&e))
  {
   keyboard();
  }
  
 }

}
