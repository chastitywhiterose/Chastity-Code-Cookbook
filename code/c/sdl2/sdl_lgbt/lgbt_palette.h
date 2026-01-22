/*lgbt_palette.h*/


struct palette
{
 int length,index,index1;
 int *colors;
};

struct palette main_palette,gay_palette,trans_palette,pastel_palette;




void main_palette_view()
{
 int x=0;
 while(x<main_palette.length)
 {
  printf("main_palette.colors[%d]=%06X;\n",x,main_palette.colors[x]);
  x++;
 }
 printf("main_palette.length=%d;\n",main_palette.length);
}



struct palette make_gay(int n)
{
 struct palette new_palette;
 int x=0,color;
 int red=n,green=0,blue=0;

 new_palette.colors=malloc(0x1000*sizeof(*new_palette.colors));

 /*now to fill the array*/
 x=0;
 while(green<n)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  green++;
 }
 while(red>0)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  red--; 
 }
 while(blue<n)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  blue++;
 }
 while(green>0)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  green--; 
 }
 while(red<n)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  red++; 
 }
 while(blue>0)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  blue--; 
 }
 new_palette.length=x;
 new_palette.index=0;
 

 return new_palette;
}





struct palette make_trans(int n)
{
 struct palette new_palette;
 int x=0,color;
 int red=0,green=n,blue=n;

 new_palette.colors=malloc(0x1000*sizeof(*new_palette.colors));

 /*now to fill the array*/
 x=0;
 while(green>0)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  green--;
  red++;
 }

 while(green<n)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  green++;
 }

 while(green>0)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  green--;
 }

 while(green<n)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  green++;
  red--;
 }



 new_palette.length=x;
 new_palette.index=0;
 

 return new_palette;
}









struct palette make_pastel(int n)
{
 struct palette new_palette;
 int x=0,color;
 int red=n,green=n,blue=0;

 new_palette.colors=malloc(0x1000*sizeof(*new_palette.colors));

 /*now to fill the array*/
 x=0;
 while(blue<n)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  blue++;
  red--;
 }
 while(red<n)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  red++;
  green--;
 }
 while(green<n)
 {
  color=255*red/n;color*=256;color+=255*green/n;color*=256;color+=255*blue/n;new_palette.colors[x]=color;
  x++;
  green++;
  blue--;
 }

 new_palette.length=x;
 new_palette.index=0;
 

 return new_palette;
}





/*
This uses direct pixel access of the source lgbt font to draw only when the source pixel is not black.
however this one uses the main_palette to change colors!
*/
void lgbt_draw_text_pal(const char *s,int cx,int cy,int scale)
{
 int x,y,i,c,cx_start=cx;
 int sx,sy,sx2,sy2,dx,dy; /*x,y coordinates for both source and destination*/
 Uint32 pixel,r,g,b; /*pixel that will be read from*/
 SDL_Rect rect_source,rect_dest;
 int char_width=main_lgbt.width/95; /*there are 95 characters in my font files*/
 int char_height=main_lgbt.height;

 if(main_lgbt.pixels==NULL){/*printf("Error: Font is NULL!\n");*/return;}

 main_palette.index1=main_palette.index;

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
      
      if(main_palette.index>=main_palette.length)
      {
       main_palette.index=0;
      }

      pixel=main_palette.colors[main_palette.index];

      main_palette.index++;

      
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

 main_palette.index=(main_palette.index1+1)%main_palette.length;
 /*printf("main_palette.index=%d\n",main_palette.index);*/

}










void lgbt_demo_pal()
{
 int scale=12;
 int text_x=16;

 delay=1000/fps;

 loop=1;
 while(loop)
 {
  sdl_time = SDL_GetTicks();
  sdl_time1 = sdl_time+delay;

  SDL_SetRenderDrawColor(renderer,0,0,0,255);
  SDL_RenderClear(renderer);

  main_color=0x00FFFF;

  main_palette=gay_palette;
  lgbt_draw_text_pal("Gay",text_x,main_lgbt.height*1*scale,scale);
  gay_palette=main_palette;

  main_palette=trans_palette;
  lgbt_draw_text_pal("Transgender",text_x,main_lgbt.height*3*scale,scale);
  trans_palette=main_palette;

  main_palette=pastel_palette;
  lgbt_draw_text_pal("Pastel",text_x,main_lgbt.height*5*scale,scale);
  pastel_palette=main_palette;

 
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





