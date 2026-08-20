#include "chastelib.bi"

'define screen size variables before the graphics header
dim shared as integer screen_width=1280,screen_height=720

'this section creates the window and loads the font from an image

'create the screen based on global variables
screenRes screen_width, screen_height, 32

'set up known dimensions of the font image that already exist
dim as integer font_image_width=128,font_image_height=128

'the size in pixels of each character in the font image
dim as integer font_char_width=8,font_char_height=8

dim shared font_image As Any Ptr

font_image=ImageCreate( 128, 128 )

bload "font-8.bmp", font_image

'everything above is necessary because the following included files
'use the shared screen and font image variables

#include "chastelib-graphics.bi"
#include "chastelib-graphics-demo.bi"

print "screen_width";screen_width
print "screen_height";screen_height

'demo_font_8 'display the chars to screen
'demo_font_8_save() 'display but also save the file






'draw the font picture to the center of screen
put (screen_width/2-64,screen_height/2-64), font_image


demo_putchar(65)

'keep the window open until a key is pressed
Sleep

ImageDestroy( font_image )

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/

