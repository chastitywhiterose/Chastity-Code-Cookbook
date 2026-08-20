'demo to draw all characters to the screen in 8x8 font

sub demo_font_8

' Set the screen mode to size I want and 32 bits true color
ScreenRes 128, 128, 32

'optionally change font

'width screen_width/8,screen_height\8  'use 8x8 font (default)
width screen_width\8,screen_height\16 'use 8x16 font


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

'same demo as above but with less code and comments
'also saves the file

sub demo_font_8_save

screenRes 128, 128, 32

'color &hFF00FF,&h000000 ' white text, black background
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
y+=1
wend

bsave "font-8.bmp", 0

' keep window open to view until keypress
sleep

end sub

'function to draw a character from the pre-existing font that must be
'loaded before calling this function

sub demo_putchar(c as integer)

print c 'print again but to the graphics window

dim as integer x,y,a

x=c mod 16
y=c/16

print x;y

dim as integer x1,y1,x2,y2,pixel

x1=x*8
y1=y*8

x2=x1+8
y2=y1+8

while x1<x2

pixel=point(x1,y1,font_image)

if pixel=&hFF000000 then
print 0
else
print 1
end if

'debug the pixel value using my chastelib functions
'radix=16
'print intstr(pixel)

x1+=1
wend





end sub