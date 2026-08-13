#include "chastelib.bi"

dim as integer screen_width=1280,screen_height=720

' Set the screen mode to size I want and 32 bits true color
ScreenRes 1280, 720, 32

'optionally change font

'width screen_width/8,screen_height\8  'use 8x8 font (default)
width screen_width\8,screen_height\16 'use 8x16 font

' Draw color bands in a diagonal pattern over the whole screen
For y As Long = 0 To screen_height-1
    For x As Long = 0 To screen_width-1
        PSet (x,y),(x xor y ) shl 16
    Next x
Next y

' Display the text "Hello World!!" over the lines we've drawn, in the top-left hand corner

color &hFF00FF,&h00FF00 'set foreground and background text color using hex RGB codes

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

if(a>=32) and (a<=126) then
print " "+chr(a);
endif

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
