/*
# Binary Bit Map

This C library file was created for my book, Chastity's Code Cookbook. It demonstrates that it is possible to create image files with only the C standard library.
All code was written entirely with by Chastity White Rose. The design is focused on black and white images only, but the format used for pixels is 32 bit unsigned integers.
This code is therefore extendable to use for any colors if I wish to expand it.
*/

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

/*
frees the memory the pointer points to, but only if the pointer is not already NULL.
*/
void BBM_free(uint32_t *pointer)
{
 if(pointer!=NULL){free(pointer);pointer=NULL;}
}

/*
 The function that saves the pixels to a PBM file.
 0 is black and 1 is White.
 Each byte contains 8 pixels. One per bit.
*/
void BBM_SavePBM_Pixels(uint32_t *p,uint32_t width,uint32_t height,FILE* fp)
{
 uint32_t x,y,pixel,r,g,b,gray,bitcount,bits,bpp=1;

 y=0;
 while(y<height)
 {
  bitcount=0;
  bits=0;
  x=0;
  while(x<width)
  {
   pixel=p[x+y*width];
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

}

/*
Saves to PBM. My favorite already existing format because of it's simplicity. Next to my own BBM format this is the most efficient uncompressed storage of black and white pixels I have seen, unless there is another format I don't know about.
*/
void BBM_SavePBM(uint32_t *p,uint32_t width,uint32_t height,const char* filename)
{
 FILE* fp;
 fp=fopen(filename,"wb+");
 if(fp==NULL){printf("Failed to create file \"%s\".\n",filename); return;}
 else{/*printf("File \"%s\" opened.\n",filename);*/}
 fprintf(fp,"P4\n"); fprintf(fp,"%d %d\n",width,height);

 BBM_SavePBM_Pixels(p,width,height,fp);

 fclose(fp);
 /*printf("Saved to file: %s\n",filename);*/
}

/*
Code for filling the image with a checkerboard. This is my most precious of programming creations!
*/
void chastity_checker(uint32_t *p,uint32_t width,uint32_t height,uint32_t square_size,uint32_t color0,uint32_t color1)
{
 uint32_t x,y=0,index=0,index1,bitcountx,bitcounty=0;
 while(y<height)
 {
  index1=index;
  bitcountx=0;
  x=0;
  while(x<width)
  {
   if(index==0){p[x+y*width]=color0;}
    else       {p[x+y*width]=color1;}
   bitcountx+=1;if(bitcountx==square_size){bitcountx=0;index^=1;}
   x+=1;
  }
  index=index1;
  bitcounty+=1;if(bitcounty==square_size){bitcounty=0;index^=1;}
  y+=1;
 }
}
