sub demo_font_8

' Set the screen mode to size I want and 32 bits true color
ScreenRes 128, 128, 32

'optionally change font

'width screen_width/8,screen_height\8  'use 8x8 font (default)
width screen_width\8,screen_height\16 'use 8x16 font

rect_size=16    'size of each square in checkerboard
'chaste_checker

'set foreground and background text color using hex RGB codes

color &hFFFFFF,&h000000 ' white text, black background
'color &h000000,&hFFFFFF ' black text, white background

dim as integer x,y,a

a=0

y=1
while y<=16

x=1
while x<=16

locate y,x

'if(a>=32) and (a<=126) then
print chr(a);
'endif

a+=1

x+=1
wend
y+=1:
wend

' Save screen as BMP
'BSave "screen.bmp", 0

' keep window open to view until keypress
sleep

end sub
