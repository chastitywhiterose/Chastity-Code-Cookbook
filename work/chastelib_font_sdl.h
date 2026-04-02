/*
chastity font SDL2 surface version

SDL surfaces are easy to work with and this was the original way I implemented my own text writing library.
There is an incomplete version that uses an SDL renderer but offers no advantages over this one.
*/


/*
chastelib font structure

In is version of my SDL2 font extension, a surface is used as an image which contains the printable characters.
The data in it will be loaded by another function from an image file.
*/
struct chaste_font
{
 int char_width; /*width of a character*/
 int char_height; /*height of a character*/
 int char_scale; /*multiplier of original character size used in relevant functions*/
 SDL_Surface *surface; /*the surface of the image of loaded font*/
};

/*global font that will be reused many times*/
struct chaste_font main_font;

/*function to load a font and return a structure with the needed data to draw later*/
struct chaste_font chaste_font_load(char *s)
{
 struct chaste_font new_font;
 SDL_Surface *temp_surface;
 printf("Loading font: %s\n",s);

 /*load bitmap to temporary surface*/
 temp_surface=SDL_LoadBMP(s);

 /*convert to same surface as screen for faster blitting*/
 new_font.surface=SDL_ConvertSurface(temp_surface, surface->format);
 
 /*free the temp surface*/
 SDL_DestroySurface(temp_surface); 

 if(new_font.surface==NULL){printf( "SDL could not load image! SDL_Error: %s\n",SDL_GetError());return new_font;}

 /*
  by default,font height is detected by original image height
  but the font width is the width of the image divided by 95
  because there are exactly 95 characters in the font format that I created.
 */
 new_font.char_width=new_font.surface->w/95; /*there are 95 characters in my font files*/
 new_font.char_height=new_font.surface->h;

 if(new_font.char_height==0)
 {
  printf("Something went horribly wrong loading the font from file:\n%s\n",s);
 }
 else
 {
  /*printf("Font loaded correctly\n");*/
  printf("Size of each character in loaded font is %d,%d\n",new_font.char_width,new_font.char_height);
  new_font.char_scale=1;
  printf("Character scale initialized to %d\n\n",new_font.char_scale);
 }

 return new_font;
}

/*global variables to control the cursor in the putchar function*/
int cursor_x=0,cursor_y=0;
int line_spacing_pixels=1; /*optionally space lines of text by this many pixels*/

/*
This function is designed to print a single character to the current surface of the main window
This means that it can be called repeatedly to write entire strings of text
*/

int sdl_putchar(char c)
{
 int x,y; /*used as coordinates for source image to blit from*/
 int error=0; /*used only for error checking*/
 SDL_Rect rect_source,rect_dest;

  /*
  in the special case of a newline, the cursor is updated to the next line
  but no character is printed.
  */
  if(c=='\n')
  {
   cursor_x=0;
   cursor_y+=main_font.char_height*main_font.char_scale;
   cursor_y+=line_spacing_pixels; /*add space between lines for readability*/
  }
  else
  {
   x=(c-' ')*main_font.char_width; /*the x position of where this char is stored in the font source bitmap*/
   y=0*main_font.char_height;      /*the y position of where this char is stored in the font source bitmap*/

   rect_source.x=x;
   rect_source.y=y;
   rect_source.w=main_font.char_width;
   rect_source.h=main_font.char_height;

   rect_dest.x=cursor_x;
   rect_dest.y=cursor_y;
   rect_dest.w=main_font.char_width*main_font.char_scale;
   rect_dest.h=main_font.char_height*main_font.char_scale;

   /*copy the character to the screen (including scale of character)*/
   error=SDL_BlitSurfaceScaled(main_font.surface,&rect_source,surface,&rect_dest,SDL_SCALEMODE_NEAREST);
   if(!error){printf("Error: %s\n",SDL_GetError());}
   
   /*
   copy the character directly but ignore scale
   this will result in the tiny character from the source font
   and is only intended as a joke
   */
   /*error=SDL_BlitSurface(main_font.surface,&rect_source,surface,&rect_dest);*/
   if(!error){printf("Error: %s\n",SDL_GetError());}

   cursor_x+=main_font.char_width*main_font.char_scale;
  }

 return c;
}

/*
SDL3 notes:

In the SDL_BlitSurfaceScaled function, the final argument is what method is used for scaling.
https://wiki.libsdl.org/SDL3/SDL_ScaleMode

SDL_SCALEMODE_LINEAR makes everything look blurry. I don't like it!
SDL_SCALEMODE_NEAREST makes it look correct like in SDL2

*/

/*
 This function is the SDL equivalent of my putstring function.
 Besides writing the text to an SDL window, it still writes it to the terminal
 This way I can always read it from the terminal and debug if necessary.
*/

int sdl_putstring(const char *s)
{
 int count=0;                    /*used to calcular how many bytes will be written*/
 const char *p=s;                /*pointer used to find terminating zero of string*/
 while(*p)
 {
  sdl_putchar(*p); /*print this character to the SDL window using a function I wrote*/
  p++;             /*increment the pointer*/
 } 
 count=p-s;                      /*count is the difference of pointers p and s*/
 fwrite(s,1,count,stdout);       /*https://cppreference.com/w/c/io/fwrite.html*/
 return count;                   /*return how many bytes were written*/
}

/*
 This function writes a string but wraps the text to always fit the screen.
*/

int sdl_putstring_wrapped(const char *s)
{
 int count=0;     /*used to calcular how many bytes will be written*/
 const char *p=s; /*pointer used to find terminating zero of string*/
 const char *w;   /*pointer used to check length of string for wrapping text*/
 int wx;          /*x position used to see if we need to wrap words*/
 while(*p)
 {
  w=p; /*the wrap pointer is used in a loop to determine if the "word" will fit on the current line*/
  wx=cursor_x; 
  while(*w>=0x21 && *w<=0x7E) /*while the chars in current word are not special character*/
  {
   wx+=main_font.char_width*main_font.char_scale;
   w++;
  }
  /*if the previous loop goes off the right edge of window, wrap to next line*/
  if(wx>=width)
  {
   cursor_x=0;
   cursor_y+=main_font.char_height*main_font.char_scale;
   cursor_y+=line_spacing_pixels; /*add space between lines for readability*/
   putchar('\n'); /*insert newline to terminal*/
  }
  sdl_putchar(*p); /*print this character to the SDL window using a function I wrote*/
  putchar(*p);     /*print to stdout with libc putchar*/
  p++;             /*increment the pointer*/
 } 
 count=p-s;                      /*count is the difference of pointers p and s*/
 return count;                   /*return how many bytes were written*/
}

/*
A function to clear the screen and reset the cursor to the top left
This makes sense because the Linux clear command does the same thing
*/

void sdl_clear()
{
 cursor_x=0;cursor_y=0;
 SDL_FillSurfaceRect(surface,NULL,0x000000);
 
 /*
 these next lines use escape sequences to also clear the terminal
 and reset the terminal cursor so it matches the SDL cursor by this library
*/
 putstring("\x1B[2J"); /*clear the terminal with an escape sequence*/
 putstring("\x1B[H"); /*reset terminal cursor to home*/
}

/*
 a function with a loop which will only end if we click the X or press escape
 This function serve as a useful way to keep the SDL Window on the screen
 so I can see the text of I have drawn to it.
 It is also something I can copy paste into larger input loops.
*/

void sdl_wait_escape()
{
 int loop=1;
 while(loop)
 {
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_EVENT_QUIT){loop=0;}
   if(e.type == SDL_EVENT_KEY_UP)
   {
    if(e.key.key==SDLK_ESCAPE){loop=0;}
   }
  }
 }
}

