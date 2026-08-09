#include "chastelib.bi"
#include "chastdin.bi"

dim shared as integer chastack(256)
dim shared as integer csi=0 'Chastity's Stack Index

radix=10

dim as integer a,b
dim as string s=""

print "Welcome to the BASIC input program!"
print "This program asks for a string from the user and shows information."
print "It ends as soon as the string is ""exit""."
print

while s<>"exit"

s=getstr()

print "Information about the string:"
print
print "string: ";s
print "length: ";len(s)


'print entire stack
if s="?" then
 b=csi
 while csi>0
  print intstr(chastack(csi))
  csi-=1
 wend
 csi=b

elseif s="add" then
b=chastack(csi)
csi-=1
a=chastack(csi)
a+=b
chastack(csi)=a
stack_check()

else

'try to interpret string as a number if not empty
if len(s)<>0 then
a=strint(s)
if strint_errors<>0 then
print s;" cannot be added to the stack because it is not a valid number"
else
print intstr(a);" was added to the stack"
end if
csi+=1
chastack(csi)=a
end if

end if



/'
print
print "Results from passing string to strint function:"
print
a=strint(s)
print "strint result number: ",a
print "string errors: ";strint_errors
print
'/

wend

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/

