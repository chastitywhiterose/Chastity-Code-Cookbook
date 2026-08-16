dim shared as integer rect_size=8

/'
 this function draws a checkerboard. it is highly optimized because it does not switch colors during the function. it only draws half of the checkerboard squares and leaves the remaining areas the same as the background
'/
sub chaste_checker()
 dim as integer x,y,index,index1
 dim as integer rect_x,rect_y,rect_w,rect_h

 'draw filled rectangle with the line function
 'fill the whole screen
  line (0,0)-(screen_width,screen_height), &H000000,bf
 
 index=0
 rect_x=0
 rect_y=0
 rect_w=rect_size
 rect_h=rect_size

 y=0
 while(y<screen_height)
  index1=index
  x=0
  while(x<screen_width)
  if(index=1) then

   'draw filled rectangle with the line function
   line (x,y)-(x+rect_w-1,y+rect_h-1), &HFFFFFF, bf

   end if
   index=index xor 1
   x+=rect_size
  wend
  index=index1 xor 1
  y+=rect_size
  wend

end sub



' Notes

'The line function actually can draw rectangles, despite its name
'https://www.freebasic.net/wiki/KeyPgLinegraphics