#include "chastelib.bi"

'define screen size variables before the graphics header
dim shared as integer screen_width=1280,screen_height=720

#include "chastelib-graphics.bi"
#include "chastelib-graphics-demo.bi"

print "screen_width";screen_width
print "screen_height";screen_height

'demo_font_8 'display the chars to screen
'demo_font_8_save() 'display but also save the file

demo_putchar(48)

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/

