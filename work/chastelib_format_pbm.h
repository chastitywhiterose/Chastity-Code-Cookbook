/*You can change black and white to other colors.*/
uint32_t u32bw[]={0x000000,0xFFFFFF};

/*
This is a custom written function to load a PBM file and return it as a new SDL_Surface*.
I wrote the SDL_LoadPBM function precisely because I wanted to use an open file format
that was not associated with Microsoft.

The PBM format also doesn't waste as much space as the BMP format.
Files are slightly smaller but contain all of the data needed
to know which pixels are black or white.
*/

SDL_Surface* SDL_LoadPBM(const char* filename)
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
 if(fp==NULL){printf("Failed to read file \"%s\".\n",filename); p=NULL; return NULL;}
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
 Create an SDL surface to store width*height pixels
 SDL_CreateRGBSurface
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

 return new_surface;
}











