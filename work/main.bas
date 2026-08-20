#include "chastelib.bi"

'define screen size variables before the graphics header
dim shared as integer screen_width=1280,screen_height=720

#include "chastelib-graphics.bi"
#include "chastelib-graphics-demo.bi"

print "screen_width";screen_width
print "screen_height";screen_height

'demo_font_8 'display the chars to screen
'demo_font_8_save() 'display but also save the file

'demo_putchar(48)

'this section creates the window and loads the font from an image

'create the screen based on global variables
screenRes screen_width, screen_height, 32

'set up known dimensions of the font image that already exist
dim as integer font_image_width=128,font_image_height=128

'the size in pixels of each character in the font image
dim as integer font_char_width=8,font_char_height=8

'allocate an image of size equal to existing font image
dim font_image As Any Ptr = ImageCreate( font_image_width, font_image_height )


bload "font-8.bmp", font_image
'draw the font picture to the center of screen
put (screen_width/2-64,screen_height/2-64), font_image
ImageDestroy( font_image )
Sleep

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/

