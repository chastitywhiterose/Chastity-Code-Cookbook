#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "bbm.h"
int main()
{
 uint32_t *p=NULL; /*The pointer to the pixels*/
 int width=720,height=720; /*The size of the image.*/
 int square_size=90; /*size of each square in the checkerboard that will be created*/
 uint32_t colors[]={0x000000,0xFFFFFF};

 p=BBM_malloc(width,height);

 chastity_checker(p,width,height,square_size,colors[1],colors[0]);

 BBM_SavePBM(p,width,height,"image.pbm");

 BBM_free(p);

 return 0;
}
