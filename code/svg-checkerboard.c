#include <stdio.h>
int main()
{
 int width=720,height=720;
 int x=0,y=0;
 int index=0,index1=0;
 int rect_width=90,rect_height=90;

 printf("<svg width=\"%d\" height=\"%d\">\n",width,height);

 printf("<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"%d\" style=\"fill:#FFFFFF;\" />\n",x,y,width,height);

 y=0;
 while(y<height)
 {
  index1=index;
  x=0;
  while(x<width)
  {
   if(index==1)
   {
    printf("<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"%d\" style=\"fill:#000000;\" />\n",x,y,rect_width,rect_height);
   }
   index^=1;
   x+=rect_width;
  }
  index=index1^1;
  y+=rect_height;
 }

 printf("</svg>\n");

 return 0;
}
