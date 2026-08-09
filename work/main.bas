#include "chastelib.bi"

dim as integer a,b

radix=10



dim as string s=""

while s<>"exit"

input "enter a string from the keyboard: ",s

print "string: ";s
print "length: ";len(s)

a=strint(s)
print "strint result number: ",a
print "string errors: ";strint_errors

wend

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
