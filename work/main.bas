#include "chastelib.bi"

'define screen size variables before the graphics header
dim shared as integer screen_width=1280,screen_height=720
#include "chastelib-graphics.bi"

' Set the screen mode to size I want and 32 bits true color
ScreenRes 1280, 720, 32

'optionally change font

'width screen_width/8,screen_height\8  'use 8x8 font (default)
width screen_width\8,screen_height\16 'use 8x16 font

chaste_checker

color &h000000,&hFFFFFF 'set foreground and background text color using hex RGB codes

dim as integer cursor_x=3,cursor_y=2,y_top=7

locate cursor_y,cursor_x
print "Counting Program with FreeBASIC Graphics"

cursor_x=3
cursor_y=y_top
locate cursor_y,cursor_x

' Keep the window open until the user presses a key

dim as integer a,b,c

radix=16

a=0
b=strint("100")
c=32

while a<b

locate cursor_y,cursor_x

radix=2
int_width=8
print intstr(a);" ";

radix=16
int_width=2
print intstr(a);" ";

radix=10
int_width=3
print intstr(a);

'if(a>=32) and (a<=126) then
print " "+chr(a);
'endif

'print

a+=1
cursor_y+=1:

'cursor math to display to the right of last column of numbers
if (a mod c)=0 then
cursor_x+=20
cursor_y=y_top
end if

wend

sleep

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
