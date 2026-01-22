/*
To avoid corrupting my font library during development, I created this source file to make a set of functions entirely dedicated to my new file format.
*/

struct lgbt
{
 Uint32 width,height,bpp;
 Uint32 *pixels;
};

struct lgbt main_lgbt;

int main_color=0xFFFFFF; /*global color for all drawn text*/

/*loads data into an lgbt image by first loading a bitmap file and then copying all the data over*/
struct lgbt lgbt_load_bmp(const char *s)
{
 int x,y;
 SDL_Surface *temp_surface,*temp_surface1;
 Uint32 *ssp; /*ssp is short for Source Surface Pointer*/
 struct lgbt new_lgbt;

 /*load bitmap to temporary surface*/
 temp_surface=SDL_LoadBMP(s);

 /*convert to BGRA32 pixel format for easy handling for later functions*/
 temp_surface1=SDL_ConvertSurfaceFormat(temp_surface, SDL_PIXELFORMAT_BGRA32, 0);

 /*set the initial data for the lgbt structure copied from the SDL_Surface*/
 new_lgbt.width=temp_surface1->w;
 new_lgbt.height=temp_surface1->h;
 new_lgbt.bpp=32;

 printf("new_lgbt width=%d height=%d bpp=%d\n",new_lgbt.width,new_lgbt.height,new_lgbt.bpp);

 new_lgbt.pixels=(uint32_t*)malloc((new_lgbt.width*new_lgbt.height)*sizeof(*new_lgbt.pixels));
 if(new_lgbt.pixels==NULL){printf("Error: malloc failed,\n");}
 else
 {
  printf("Allocated the pixels for lgbt image.\n");

  ssp=(Uint32*)temp_surface1->pixels;

  /*copy the pixels from the surface to this structure*/
  y=0;
  while(y<new_lgbt.height)
  {
   x=0;
   while(x<new_lgbt.width)
   {
    new_lgbt.pixels[x+y*new_lgbt.width]=ssp[x+y*new_lgbt.width] & 0xFFFFFF;
    /*printf("%06X %d,%d\n",new_lgbt.pixels[x+y*new_lgbt.width],x,y);*/
    x++;
   }
   y++;
  }
  
 }

 SDL_FreeSurface(temp_surface);
 SDL_FreeSurface(temp_surface1);

 return new_lgbt;
}










/*
Saves to PBM(Portable Bitmap Format). This format takes less space than Windows BMP files because the header is a lot smaller but the pixel data is stored as 1 bit per pixel. It doesn't get smaller than that without compression.
*/
void lgbt_save_pbm(const char* filename)
{
 uint32_t x,y,pixel,r,g,b,gray,bitcount,bits,bpp=1;

 FILE* fp;
 fp=fopen(filename,"wb+");
 if(fp==NULL){printf("Failed to create file \"%s\".\n",filename); return;}
 else{/*printf("File \"%s\" opened.\n",filename);*/}
 fprintf(fp,"P4\n"); fprintf(fp,"%d %d\n",main_lgbt.width,main_lgbt.height);

 /*start of pixel writing section*/
 y=0;
 while(y<main_lgbt.height)
 {
  bitcount=0;
  bits=0;
  x=0;
  while(x<main_lgbt.width)
  {
   pixel=main_lgbt.pixels[x+y*main_lgbt.width];
   r=(pixel&0xFF0000)>>16;
   g=(pixel&0x00FF00)>>8;
   b=(pixel&0x0000FF);
   gray=(r+g+b)/3;
   gray>>=8-bpp; gray^=1;
   bits<<=bpp;
   bits|=gray;
   bitcount+=bpp;
   x++;
   while(bitcount>=8)
   {
    fputc(bits,fp);
    bitcount-=8;
   }
  }

  /*If width is not a multiple of 8 pad the bits to a full byte*/
  while(bitcount!=0)
  {
   bits<<=1;
   bitcount++;
   if(bitcount==8)
   {
    fputc(bits,fp);
    bitcount=0;
   }
  }
  y++;
 }

 /*end of pixel writing section*/


 fclose(fp);
 printf("Saved to file: %s\n",filename);
}










/*Loads from PBM(Portable Bitmap Format)*/
struct lgbt lgbt_load_pbm(const char *filename)
{
 char s[0x10];
 int x,y,pixel,x2,c,bitcount,bits;
 struct lgbt new_lgbt;
 FILE* fp;
 fp=fopen(filename,"rb");
 printf("This function loads a LGBT file into a structure.\n");
 if(fp==NULL)
 {
  printf("Failed to read file \"%s\": Doesn't exist.\n",filename);
  new_lgbt.pixels=NULL; return new_lgbt;}

 fscanf(fp,"%s",s);
 if(!strcmp(s,"P4")){printf("Correct \"%s\" header!\n",s);}
 else{printf("\"%s\" is not the correct header!\n",s);}
 fscanf(fp,"%u",&new_lgbt.width);
 fscanf(fp,"%u",&new_lgbt.height);
 fgetc(fp);
 new_lgbt.bpp=1;

 printf("new_lgbt width=%d height=%d bpp=%d\n",new_lgbt.width,new_lgbt.height,new_lgbt.bpp);

 new_lgbt.pixels=(uint32_t*)malloc((new_lgbt.width*new_lgbt.height)*sizeof(*new_lgbt.pixels));
 if(new_lgbt.pixels==NULL){printf("Error: malloc failed,\n");}
 else
 {
  printf("Allocated the pixels for lgbt image.\n");


 y=0;
 while(y<new_lgbt.height)
 {


  bitcount=0;
  x=0;
  while(x<new_lgbt.width)
  {
   if(bitcount%8==0)
   {
    c=fgetc(fp);
    if(feof(fp))
    {
     printf("End of file reached.\n");
    }
      
   }
   
   bits=c >> (8-new_lgbt.bpp);
   c<<=new_lgbt.bpp;
   c&=255;
   bitcount+=new_lgbt.bpp;

   bits^=1;

   /*convert gray into a 24 bit RGB equivalent.*/
   pixel=0;
   x2=0;
   while(x2<24)
   {
    pixel<<=new_lgbt.bpp;
    pixel|=bits;
    x2+=new_lgbt.bpp;
   }

    new_lgbt.pixels[x+y*new_lgbt.width]=pixel;
    x++;
   }
   y++;


  }

  
 }

 fclose(fp);
 printf("Loaded from file: %s\n",filename);
 return new_lgbt;
}









/*
A quick dirty replacement for never needing to use fwrite to write my integers! However the catch is that it only works for little endian. For this reason I choose little endian as the format the binary integers will take in my own image formats I am creating. It writes integer i to file pointer fp using count bytes. Most PCs these days can't actually do more than 32 or 64 bits.

This function was necessary so that my code won't completely fail if I do programming on a different CPU in which case fwrite would spit out the big endian byte order. Besides it wasn't too hard to write and requires only 3 arguments instead of 4.
*/
void fputint(unsigned long int i,FILE *fp,int count)
{
 while(count>0)
 {
  fputc(i,fp);
  i>>=8;
  count--;
 }
}


/*The reverse process gets an integer of the specified number of bytes in little endian format.*/
unsigned long int fgetint(FILE *fp,int count)
{
 unsigned long int i=0,c,x;
 
 x=0;
 while(count>0)
 {
  c=fgetc(fp);
  i+=c<<=x;
  x+=8;
  count--;
 }

 return i;
}





/*
Saves to my own format which is named LGBT.
*/
void lgbt_save(const char* filename)
{
 uint32_t x,y,pixel,r,g,b,gray,bitcount,bits,bpp=1;
 FILE* fp;

 if(main_lgbt.pixels==NULL)
 {
  printf("Error: Font is NULL!\n");
  printf("Saving file cancelled!\n");
  return;
 }

 fp=fopen(filename,"wb+");
 if(fp==NULL){printf("Failed to create file \"%s\".\n",filename); return;}
 else{/*printf("File \"%s\" opened.\n",filename);*/}

 fputs("LGBT",fp);
 fputint(main_lgbt.width,fp,4);
 fputint(main_lgbt.height,fp,4);
 fputint(bpp,fp,4);

 /*start of pixel writing section*/
 y=0;
 while(y<main_lgbt.height)
 {
  bitcount=0;
  bits=0;
  x=0;
  while(x<main_lgbt.width)
  {
   pixel=main_lgbt.pixels[x+y*main_lgbt.width];
   r=(pixel&0xFF0000)>>16;
   g=(pixel&0x00FF00)>>8;
   b=(pixel&0x0000FF);
   gray=(r+g+b)/3;
   gray>>=8-bpp; /*gray^=1;*/
   bits<<=bpp;
   bits|=gray;
   bitcount+=bpp;
   x++;
   while(bitcount>=8)
   {
    fputc(bits,fp);
    bitcount-=8;
   }
  }

  /*If width is not a multiple of 8 pad the bits to a full byte*/
  while(bitcount!=0)
  {
   bits<<=1;
   bitcount++;
   if(bitcount==8)
   {
    fputc(bits,fp);
    bitcount=0;
   }
  }
  y++;
 }

 /*end of pixel writing section*/


 fclose(fp);
 printf("Saved to file: %s\n",filename);
}







/*
A function to load my lgbt image format.

This function uses fread to read the data from the file in a way that works best with standard library functions.
*/
struct lgbt lgbt_load(const char *filename)
{
 char id_string[16];
 int x,y,pixel,x2,c,bitcount,bits;
 FILE* fp;
 struct lgbt new_lgbt;
 new_lgbt.pixels=NULL; /*default to NULL for pixels before allocation*/

 fp=fopen(filename,"rb");
 printf("This function loads a LGBT file into a structure.\n");
 if(fp==NULL)
 {
  printf("Failed to read file \"%s\": Doesn't exist.\n",filename);
  return new_lgbt;
 }

 fread(id_string,sizeof(*id_string),4,fp);
 if(strncmp(id_string,"LGBT",4)!=0){printf("Error not an LGBT file!\n");return new_lgbt;}
 fread(&new_lgbt.width,4,1,fp);
 fread(&new_lgbt.height,4,1,fp);
 fread(&new_lgbt.bpp,4,1,fp);

 printf("new_lgbt width=%d height=%d bpp=%d\n",new_lgbt.width,new_lgbt.height,new_lgbt.bpp);

 new_lgbt.pixels=(uint32_t*)malloc((new_lgbt.width*new_lgbt.height)*sizeof(*new_lgbt.pixels));
 if(new_lgbt.pixels==NULL){printf("Error: malloc failed,\n");}
 else
 {
  printf("Allocated the pixels for lgbt image.\n");

  y=0;
  while(y<new_lgbt.height)
  {


   bitcount=0;
   x=0;
   while(x<new_lgbt.width)
   {
    if(bitcount%8==0)
    {
     c=fgetc(fp);
     if(feof(fp))
     {
      printf("End of file reached.\n");
     }
      
    }
   
    bits=c >> (8-new_lgbt.bpp);
    c<<=new_lgbt.bpp;
    c&=255;
    bitcount+=new_lgbt.bpp;

   /*bits^=1;*/

    /*convert gray into a 24 bit RGB equivalent.*/
    pixel=0;
    x2=0;
    while(x2<24)
    {
     pixel<<=new_lgbt.bpp;
     pixel|=bits;
     x2+=new_lgbt.bpp;
    }

    new_lgbt.pixels[x+y*new_lgbt.width]=pixel;
    x++;
   }
   y++;

  }
  
 }

 fclose(fp);
 printf("Loaded from file: %s\n",filename);
 return new_lgbt;
}

/*
loads my lgbt format

This one is the first that I wrote which does not use fread and instead uses my fgetint function. This one works and I will always keep it but I am planning to write a simpler function that uses fread to quickly read data into the integers.
*/
struct lgbt lgbt_load_1(const char *filename)
{
 int x,y,pixel,x2,c,bitcount,bits;
 struct lgbt new_lgbt;
 FILE* fp;
 fp=fopen(filename,"rb");
 printf("This function loads a LGBT file into a structure.\n");
 if(fp==NULL)
 {
  printf("Failed to read file \"%s\": Doesn't exist.\n",filename);
  new_lgbt.pixels=NULL; return new_lgbt;}

 x=fgetint(fp,4);
 /*printf("id=%X\n",x);*/
 if(x!=0x5442474C){printf("Error not an LGBT file!");}
 new_lgbt.width=fgetint(fp,4);
 new_lgbt.height=fgetint(fp,4);
 new_lgbt.bpp=fgetint(fp,4);

 printf("new_lgbt width=%d height=%d bpp=%d\n",new_lgbt.width,new_lgbt.height,new_lgbt.bpp);

 new_lgbt.pixels=(uint32_t*)malloc((new_lgbt.width*new_lgbt.height)*sizeof(*new_lgbt.pixels));
 if(new_lgbt.pixels==NULL){printf("Error: malloc failed,\n");}
 else
 {
  printf("Allocated the pixels for lgbt image.\n");


 y=0;
 while(y<new_lgbt.height)
 {


  bitcount=0;
  x=0;
  while(x<new_lgbt.width)
  {
   if(bitcount%8==0)
   {
    c=fgetc(fp);
    if(feof(fp))
    {
     printf("End of file reached.\n");
    }
      
   }
   
   bits=c >> (8-new_lgbt.bpp);
   c<<=new_lgbt.bpp;
   c&=255;
   bitcount+=new_lgbt.bpp;

   /*bits^=1;*/

   /*convert gray into a 24 bit RGB equivalent.*/
   pixel=0;
   x2=0;
   while(x2<24)
   {
    pixel<<=new_lgbt.bpp;
    pixel|=bits;
    x2+=new_lgbt.bpp;
   }

    new_lgbt.pixels[x+y*new_lgbt.width]=pixel;
    x++;
   }
   y++;

  }

  
 }

 fclose(fp);
 printf("Loaded from file: %s\n",filename);
 return new_lgbt;
}


























/*
This uses direct pixel access of the source lgbt font to draw only when the source pixel is not black.
*/
void lgbt_draw_text(const char *s,int cx,int cy,int scale)
{
 int x,y,i,c,cx_start=cx;
 int sx,sy,sx2,sy2,dx,dy; /*x,y coordinates for both source and destination*/
 Uint32 pixel,r,g,b; /*pixel that will be read from*/
 SDL_Rect rect_source,rect_dest;
 int char_width=main_lgbt.width/95; /*there are 95 characters in my font files*/
 int char_height=main_lgbt.height;

 if(main_lgbt.pixels==NULL){/*printf("Error: Font is NULL!\n");*/return;}

 i=0;
 while(s[i]!=0)
 {
  c=s[i];
  if(c=='\n'){ cx=cx_start; cy+=char_height*scale;}
  else
  {
   x=(c-' ')*char_width;
   y=0*char_height;

   /*set up source rectangle where this character will be copied from*/
   rect_source.x=x;
   rect_source.y=y;
   rect_source.w=char_width;
   rect_source.h=char_height;
 
   /*Now for the ultra complicated stuff that only Chastity can read and understand!*/
   sx2=rect_source.x+rect_source.w;
   sy2=rect_source.y+rect_source.h;
   
   dx=cx;
   dy=cy;
   
   sy=rect_source.y;
   while(sy<sy2)
   {
    dx=cx;
    sx=rect_source.x;
    while(sx<sx2)
    {
     pixel=main_lgbt.pixels[sx+sy*main_lgbt.width];
     pixel&=0xFFFFFF;
     
     if(pixel!=0) /*only if source pixel is nonzero(not black) draw square to destination*/
     {
      rect_dest.x=dx;
      rect_dest.y=dy;
      rect_dest.w=scale;
      rect_dest.h=scale;
      
      pixel=main_color;
      
      r=(pixel&0xFF0000)>>16;
      g=(pixel&0x00FF00)>>8;
      b=(pixel&0x0000FF);
      
      SDL_SetRenderDrawColor(renderer,r,g,b,255);
      SDL_RenderFillRect(renderer,&rect_dest);
      
     }
     
     sx++;
     dx+=scale;
    }
    sy++;
    dy+=scale;
   }
   /*End of really complicated section*/
   cx+=char_width*scale;
  }
  i++;
 }

}



































/*
the demo which involves drawing text but does not use the SDL specific functions!
this is important because it means having a way to draw text that does not depend on which media library is being used!
*/

void lgbt_demo()
{
 int scale=8;
 int text_x=width*1/6;

 delay=1000/fps;

 loop=1;
 while(loop)
 {
  sdl_time = SDL_GetTicks();
  sdl_time1 = sdl_time+delay;

  SDL_SetRenderDrawColor(renderer,0,0,0,255);
  SDL_RenderClear(renderer);

  main_color=0x00FFFF;
  scale=16;
  lgbt_draw_text("LGBT",text_x,main_lgbt.height*1*scale,scale);

  main_color=0xFFFF00;
  scale=8;
  lgbt_draw_text("Light\nGraphics\nBinary\nText",text_x,main_lgbt.height*5*scale,scale);

  main_color=0xFF00FF;
  lgbt_draw_text("This text was drawn with a program written by Chastity White Rose\nSimilar methods were used in her games:\nChaste Tris, Chaste Puyo, and Chaste Panel",16,main_lgbt.height*10*scale,2);
 
  SDL_RenderPresent(renderer);

  /*time loop used to slow the game down so users can see it*/
  while(sdl_time<sdl_time1)
  {
   sdl_time=SDL_GetTicks();
  }

  /*test for events and only process if they exist*/
  while(SDL_PollEvent(&e))
  {
   if(e.type == SDL_QUIT){loop=0;}
   if(e.type == SDL_KEYUP)
   {
    if(e.key.keysym.sym==SDLK_ESCAPE){loop=0;}
   }
  }
  
 }
}





