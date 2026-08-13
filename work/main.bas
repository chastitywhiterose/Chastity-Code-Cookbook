#include "chastelib.bi"

dim as integer screen_width=1280,screen_height=720

' Set the screen mode to 320*200, with 8 bits per pixel
ScreenRes 1280, 720, 32

'optionally change font

'width screen_width/8,screen_height\8  'use 8x8 font (default)
width screen_width\8,screen_height\16 'use 8x16 font

' Draw color bands in a diagonal pattern over the whole screen
For y As Long = 0 To screen_height-1
    For x As Long = 0 To screen_width-1
        PSet (x,y),(x + y)
    Next x
Next y

' Display the text "Hello World!!" over the lines we've drawn, in the top-left hand corner

print "Counting Program"

' Keep the window open until the user presses a key

dim as integer a,b

radix=16

a=0
b=strint("28")

while a<b

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

print

a+=1
wend

sleep

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
