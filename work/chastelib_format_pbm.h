/*You can change black and white to other colors.*/
uint32_t u32bw[]={0x000000,0xFFFFFF};


/*
 Allocates memory for the pixels which should be 4 bytes/32 bits per pixel. Uses standard library function malloc.
 uint32_t is a 32 bit unsigned integer type. This is why stdint.h is always included.
 I never need more than 32 bits and any more would waste memory.
*/
uint32_t* BBM_malloc(uint32_t width,uint32_t height)
{
 uint32_t *pointer;
 int length=width*height;
 pointer=(uint32_t*)malloc(length*sizeof(*pointer));
 if(pointer==NULL){printf("Error: malloc failed,\n");}
 return pointer;
}





void SDL_LoadPBM(const char* filename)
{
 char s[0x10];
 unsigned char c;
 uint32_t x,y,bit;
 uint32_t width,height;
 uint32_t *p;
 SDL_Surface *new_surface;
 FILE* fp;
 printf("This function loads a PBM file into memory.\n");
 fp=fopen(filename,"rb");
 if(fp==NULL){printf("Failed to read file \"%s\".\n",filename); p=NULL; return;}
 else{printf("File \"%s\" opened.\n",filename);}

 fscanf(fp,"%s",s);
 if(!strcmp(s,"P4")){printf("Correct \"%s\" header!\n",s);}
 else{printf("\"%s\" is not the correct header!\n",s);}
 
 printf("Reading the file for width and height values\n");
 fscanf(fp,"%u",&width);
 fscanf(fp,"%u",&height);
 printf("width=%d\n",width);
 printf("height=%d\n",height);

 /*
 Create an SDL surface with the same format as the global screen surface
 https://wiki.libsdl.org/SDL2/SDL_CreateRGBSurfaceWithFormat
 */

 new_surface=SDL_CreateRGBSurface(0,width,height,32,0,0,0,0);

/*SDL_CreateRGBSurfaceWithFormat(0, width, height, 32, *surface->format);*/


 p=new_surface->pixels;

 fgetc(fp);

 y=0;
 while(y< (height) )
 {
  int bitcount=0;
  x=0;
  while(x<(width))
  {
   int pixel;
   if(bitcount==0)
   {
    c=fgetc(fp);
    if(feof(fp)){printf("Error: End of file reached.\n");}
   }
   bit=c>>7;
   if(bit==0){pixel=u32bw[1];}else{pixel=u32bw[0];}
   p[x+y*(width)]=pixel;
   c<<=1;
   c|=bit;
   bitcount++;
   x++;
   if(bitcount==8)
   {
    bitcount=0;
    c=0;
   }
  }
  y++;
 }
 fclose(fp);
}












/*
frees the memory the pointer points to, but only if the pointer is not already NULL.
*/
void BBM_free(uint32_t *pointer)
{
 if(pointer!=NULL){free(pointer);pointer=NULL;}
}

void BBM_LoadPBM(uint32_t **p,uint32_t *width,uint32_t *height,const char* filename)
{
 char s[0x10];
 unsigned char c;
 uint32_t x,y,bit;
 FILE* fp;
 printf("This function loads a PBM file into memory.\n");
 fp=fopen(filename,"rb");
 if(fp==NULL){printf("Failed to read file \"%s\".\n",filename); *p=NULL; return;}
 else{printf("File \"%s\" opened.\n",filename);}

 fscanf(fp,"%s",s);
 if(!strcmp(s,"P4")){printf("Correct \"%s\" header!\n",s);}
 else{printf("\"%s\" is not the correct header!\n",s);}
 fscanf(fp,"%u",width);
 fscanf(fp,"%u",height);
 printf("width=%d\n",*width);
 printf("height=%d\n",*height);
 *p=BBM_malloc(*width,*height);

 fgetc(fp);

 y=0;
 while(y< (*height) )
 {
  int bitcount=0;
  x=0;
  while(x<(*width))
  {
   int pixel;
   if(bitcount==0)
   {
    c=fgetc(fp);
    if(feof(fp)){printf("Error: End of file reached.\n");}
   }
   bit=c>>7;
   if(bit==0){pixel=u32bw[1];}else{pixel=u32bw[0];}
   (*p)[x+y*(*width)]=pixel;
   c<<=1;
   c|=bit;
   bitcount++;
   x++;
   if(bitcount==8)
   {
    bitcount=0;
    c=0;
   }
  }
  y++;
 }
 fclose(fp);
}
