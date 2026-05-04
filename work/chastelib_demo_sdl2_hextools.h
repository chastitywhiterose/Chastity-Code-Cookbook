/* chastelib_demo_sdl2_hextools.h */

char RAM[0x10000];
int RAM_address_base=0;
int RAM_address_current=0;

int RAM_x=0;
int RAM_y=0;


/*
This function is an entire hex editor that allows editing a 64kb array of bytes in RAM
It was easier to make this because it doesn't use file I/O which is slightly complicated.
It was made as an early stage of the file hex editor and can still allow editing data that is not saved
*/

int sdl_chastelib_hexram()
{
 /*variables required by SDL*/
 int loop=1;
 int key=1;
 SDL_Event e;

 int x,y; /*variables for this test program*/
 int i; /*used to index the RAM sometimes*/

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

  /*start hex dump of this RAM page*/
  
  RAM_address_current=RAM_address_base;
 
 y=0;
 while(y<0x10)
 {
  int_width=8;
  putint(RAM_address_current);
  /*putint(&RAM[RAM_address_current]);*/ /*this can show the actual address but is not reliable*/
  putstr(" ");

  int_width=2;
  x=0;
  while(x<0x10)
  {
   putint(RAM[RAM_address_current+x]&0xFF);
   putstr(" ");
   x++;
  }

/*display the text of this row*/
 x=0;
 while(x<0x10)
 {
  i=RAM[RAM_address_current+x];
  if( i < 0x20 || i > 0x7E )
  {
   sdl_putchar('.');
   putchar('.');
  }
  else
  {
   sdl_putchar(i);
   putchar(i);
  }
  x++;
 }

  putstr("\n");

  RAM_address_current+=0x10;
  y++;
 }
 
 
 
 /*end of hex dump*/
  
  putstr("\nThis is the HexRAM demo\nIt displays bytes at a predefined location in RAM\n\n");
  putstr("You can also modify the bytes but nothing is saved when the program exits.\n\n");
  
  /*this section displays the index variables for indexing the RAM of the current page*/
  putstr("X=");
  putint(RAM_x);
  putstr(" Y=");
  putint(RAM_y);
  putstr(" K=");
  putint(key);
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
    
    /*by setting an index correctly once, I can reuse it for several input functions*/
    int RAM_index=RAM_address_base+RAM_x+RAM_y*0x10;
    
    /*an integer which is used when adding hexadecimal digits to the current byte indexed by x and y*/
    int i;

   
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
     if(RAM_address_base<0)
      {
       RAM_address_base+=sizeof(RAM);
      }
      break;
     case SDLK_PAGEDOWN:
      RAM_address_base+=0x100;
      if(RAM_address_base>=sizeof(RAM))
      {
       RAM_address_base=0;
      }
     break;
     
     
    case SDLK_MINUS:
    case SDLK_KP_MINUS:
     RAM[RAM_index]--;
    break;
    case SDLK_PLUS:
    case SDLK_KP_PLUS:
     RAM[RAM_index]++;
    break;
     
    }
    
    /*handle hexadecimal number input with these range of characters*/
    if( key >= '0' && key <= '9' ){i=key-'0';   RAM[RAM_index]<<=4;RAM[RAM_index]|=i;}
    if( key >= 'a' && key <= 'f' ){i=key-'a'+10;RAM[RAM_index]<<=4;RAM[RAM_index]|=i;}

    /*set the global x and y index variables from the local copies*/
    RAM_x=x;
    RAM_y=y;
   } /*end of SDL_KEYDOWN section*/


  }

  /*end of game loop*/
 }
  
 return 0;
}



/*
This is a hex editor for a file given as an argument. It uses common C functions for reading, writing, and seeking within a file

https://en.cppreference.com/c/io/fread
https://en.cppreference.com/c/io/fwrite
https://en.cppreference.com/c/io/fseek
*/

int sdl_chastelib_hexplore(int argc, char **argv)
{
 /*variables required by SDL*/
 int loop=1;
 int key=1;
 SDL_Event e;

 int x,y; /*variables for this test program*/
 
 FILE* fp; /*file pointer*/
 int file_address=0;
 int file_address_current;
 int count=0; /*keeps track of how many bytes were last read from file*/
 int i; /*used to index the RAM sometimes*/
 int eof_char='?'; /*character used by this program to show user the end of file is reached*/
 
 /*the first step is to attempt opening a file if it is given as an argument*/
 if(argc==1)
 {
  putstring
  (
   "Welcome to Hexplore! The tool for exploring a file in hexadecimal!\n\n"
   "Enter a filename as an argument to this program to read from it.\n"
   "You will then see an interface where you can modify the bytes of the file\n"
  );
  sdl_chastelib_hexram();
  return 0;
 }

 if(argc>1)
 {
  fp=fopen(argv[1],"rb+"); /*if file exists, open for read and write*/
  if(fp==NULL)
  {
   printf("File \"%s\" cannot be opened.\n",argv[1]);
   return 1;
  }
  else
  {
   /*the file was opened we will print its name*/
   putstring(argv[1]);
   putstring("\n");
   
   
   /*attempt to read 256 bytes for the first page*/
   count=fread(RAM,1,0x100,fp);
   i=count;while(i<0x100){RAM[i]=eof_char;i++;}
   
  }
 }

 
 /*now the part of the function that actually uses SDL*/

 line_spacing_pixels=1; /*empty space in pixels between lines*/
 
 main_font.color=0xFFFFFF; /*change text color*/
 main_font.char_scale=2;

 radix=16;
 int_width=1;
 
  /*a loop which will only end if we click the X or press escape*/
 while(loop)
 {
  /*start of game loop*/

 if(key) /*start of update on input section*/
 {
  sdl_clear();  /*clear the screen before we begin writing*/

  /*print the hex dump of this page of the file*/  
  file_address_current=file_address;

  y=0;
  while(y<0x10)
  {
   int_width=8;
   putint(file_address_current);
   putstr(" ");

   int_width=2;
   x=0;
   while(x<0x10)
   {
    putint(RAM[x+y*0x10]&0xFF);
    putstr(" ");
    x++;
   }
  
   /*cycle through this hex row to print valid characters if any*/
   x=0;
   while(x<0x10)
   {
    i=RAM[x+y*0x10];
    if( i < 0x20 || i > 0x7E )
    {
     sdl_putchar('.');
     putchar('.');
    }
    else
    {
     sdl_putchar(i);
     putchar(i);
    }
    x++;
   }
  
  
  
  putstr("\n");

  file_address_current+=0x10;
  y++;
 }
  
  
  putstr("\nfile \"");
  putstr(argv[1]);
  putstr("\" is opened for editing\n\n");
  
  /*this section displays the index variables for indexing the RAM of the current page*/
  putstr("X=");
  putint(RAM_x);
  putstr(" Y=");
  putint(RAM_y);
  putstr(" K=");
  putint(key);
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
    /*by setting an index correctly once, I can reuse it for several input functions*/
    int RAM_index=RAM_address_base+RAM_x+RAM_y*0x10;

    /*
     if a key has been pressed, we copy the global variables of the RAM selected
     into these temporary variables mostly just to save code space by referring to variables
     of a single letter name
    */
    x=RAM_x;
    y=RAM_y;
    
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
     

     
     
         /*change page*/
    case SDLK_PAGEUP:
     if(file_address!=0)
     {
      /*before changing page, save the modified bytes from this page back to the file*/
      fseek(fp,file_address,SEEK_SET);
      fwrite(RAM,1,count,fp);
      /*change page and read from the correct file position*/
      file_address-=0x100;
      fseek(fp,file_address,SEEK_SET);
      count=fread(RAM,1,0x100,fp);
      i=count;while(i<0x100){RAM[i]=eof_char;i++;}
     }
    break;
    case SDLK_PAGEDOWN:
     /*before changing page, save the modified bytes from this page back to the file*/
     fseek(fp,file_address,SEEK_SET);
     fwrite(RAM,1,count,fp);
     /*change page and read from the correct file position*/
     file_address+=0x100;
     fseek(fp,file_address,SEEK_SET);
     count=fread(RAM,1,0x100,fp);
      i=count;while(i<0x100){RAM[i]=eof_char;i++;}
    break;
 
     
     
    case SDLK_MINUS:
    case SDLK_KP_MINUS:
     RAM[RAM_index]--;
    break;
    case SDLK_PLUS:
    case SDLK_KP_PLUS:
     RAM[RAM_index]++;
    break;
     
    }
    
    /*handle hexadecimal number input with these range of characters*/
    if( key >= '0' && key <= '9' ){i=key-'0';   RAM[RAM_index]<<=4;RAM[RAM_index]|=i;}
    if( key >= 'a' && key <= 'f' ){i=key-'a'+10;RAM[RAM_index]<<=4;RAM[RAM_index]|=i;}

    /*set the global x and y index variables from the local copies*/
    RAM_x=x;
    RAM_y=y;
   } /*end of SDL_KEYDOWN section*/


  }

  /*end of game loop*/
 }
 
 /*
  before closing the file and ending the program, we must write the modified bytes to the file
  However, we only write (count) bytes to the file so that we don't accidentally add the full
  256 bytes of the current hex page if they were not in the original file
 */
 fseek(fp,RAM_address_base,SEEK_SET); /*seek back to the file address for this page*/
 fwrite(RAM,1,count,fp); /*write count bytes back into the original location they were read from*/
 
 fclose(fp);
  
 return 0;
}


/*
This function does not actually print anything to an SDL surface.
Instead it merely updates the cursor values like normal so that we can calculate the size of image that will be needed
 */

int sdl_putchar_dummy(char c) /*direct pixel access edition for SDL2*/
{
 int x,y; /*used as coordinates for source image to blit from*/

 Uint32 *ssp; /*ssp is short for Source Surface Pointer*/
 Uint32 *dsp; /*dsp is short for Destination Surface Pointer*/
 int source_surface_width;
 int sx,sy,sx2,sy2,dx,dy; /*x,y coordinates for both source and destination*/
 Uint32 pixel;
 /*Uint8 r,g,b;*/

 SDL_Rect rect_source,rect_dest;

 /*set the source surface pointer to the source bitmap font*/
 ssp=(Uint32*)main_font.surface->pixels;
 dsp=(Uint32*)surface->pixels;

 /*get the width of the source surface for indexing later*/
 source_surface_width=main_font.surface->w;


  /*
  in the special case of a newline, the cursor is updated to the next line
  but no character is printed.
  */
  if(c=='\n')
  {
   cursor_x=cursor_left;
   cursor_y+=main_font.char_height*main_font.char_scale;
   cursor_y+=line_spacing_pixels; /*add space between lines for readability*/
  }
  else
  {

   cursor_x+=main_font.char_width*main_font.char_scale;
  }

 return c;
}




/*
This is a complicated function but it is meant to be a standalone tool and eventually have its own executable.

It uses SDL but does not accept user input! Instead it uses command line arguments to control its behavior.

First, it calculates the size of a file.

*/


int sdl_chastelib_imagehex(int argc, char **argv)
{
 /*variables required by SDL*/


 int x,y; /*variables for this test program*/
 int hexcolumns=16,hexrows;
 
 FILE* fp; /*file pointer*/
 char *file_ram; /*pointer to a char array to be created based on file size*/
 int file_address=0;
 int file_address_current;
 int flength;
 int count=0; /*keeps track of how many bytes were last read from file*/
 int i; /*used to index the RAM sometimes*/
 int eof_char='?'; /*character used by this program to show user the end of file is reached*/
 
 /*the first step is to attempt opening a file if it is given as an argument*/
 if(argc==1)
 {
  putstring
  (
   "Welcome to imagehex! The tool for turning a file into a hexadecimal image dump.\n\n"
   "Enter a filename as an argument to this program to read from it.\n"
  );
  return 0;
 }

 if(argc>1)
 {
  fp=fopen(argv[1],"rb+"); /*if file exists, open for read and write*/
  if(fp==NULL)
  {
   printf("File \"%s\" cannot be opened.\n",argv[1]);
   return 1;
  }
  else
  {
   /*the file was opened we will print its name*/
   putstring(argv[1]);
   putstring("\n");
  }
 }
 
 /*get length of the entire file by seeking to end and then back*/
 fseek(fp,0,SEEK_END); /*go to end of file*/
 flength=ftell(fp); /*get position of the file*/
 fseek(fp,0,SEEK_SET); /*go back to the beginning*/
 
 printf("flength=%d\n");
  
 /*now we know the length of the file, we will load the whole thing*/
 file_ram=malloc(flength); /*allocate exactly enough bytes for the whole file */
  
 count=fread(file_ram,1,flength,fp); /*read all the bytes into the allocated RAM*/
 
 printf("data loaded into RAM\n");
 
 fclose(fp); /*close the file because we have all the data already*/

  /*now the part of the function that actually uses SDL*/

 line_spacing_pixels=1; /*empty space in pixels between lines*/
 
 main_font.color=0xFFFFFF; /*change text color*/
 main_font.char_scale=2;
 
 /*
 switch to the dummy function for output
 we are printing to the console for now but also calculating how many pixels will be needed to draw it all to an image
 */
 sdl_putchar=sdl_putchar_dummy;

 radix=16;
 int_width=1;
 
   /*print the hex dump of this page of the file*/  
  file_address_current=file_address;
  
  hexrows=flength/hexcolumns;

  y=0;
  while(y<hexrows)
  {
   int_width=8;
   putint(file_address_current);
   putstr(" ");

   int_width=2;
   x=0;
   while(x<0x10)
   {
    putint(RAM[x+y*0x10]&0xFF);
    putstr(" ");
    x++;
   }
  
   /*cycle through this hex row to print valid characters if any*/
   x=0;
   while(x<0x10)
   {
    i=RAM[x+y*0x10];
    if( i < 0x20 || i > 0x7E )
    {
     sdl_putchar('.');
     putchar('.');
    }
    else
    {
     sdl_putchar(i);
     putchar(i);
    }
    x++;
   }
    
  
  putstr("\n");

  file_address_current+=0x10;
  y++;
 }
 
 
 free(file_ram); /*free memory before ending function*/
  
 return 0;
}



