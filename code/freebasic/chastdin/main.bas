#include "chastelib.bi"
#include "chastdin.bi"

radix=10

dim as integer a
dim as string s=""

print "Welcome to the BASIC input program!"
print "This program asks for a string from the user and shows information."
print "It ends as soon as the string is ""exit""."
print

while s<>"exit"

input "enter a string from the keyboard: ",s

print "Information about the string:"
print
print "string: ";s
print "length: ";len(s)
print
print "Results from passing string to strint function:"
print
a=strint(s)
print "strint result number: ",a
print "string errors: ";strint_errors
print

wend

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/

