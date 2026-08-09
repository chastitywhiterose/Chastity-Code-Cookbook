#include "chastelib.bi"
#include "chastdin.bi"

dim shared as integer chastack(256)
dim shared as integer csi=0 'Chastity's Stack Index

radix=10

dim as integer a,b
dim shared as string s

sub stack_check
 if csi>0 then
  chastack(csi+1)=0 /'erase old top of stack because command was successful'/
 else
  print "Error: two numbers required for command: ";s
  csi+=1 /'increment the pointer to what it was before the failed command'/
 end if
end sub

print "Welcome to the BASIC input program!"
print "This program asks for a string from the user and shows information."
print "It ends as soon as the string is ""exit""."
print

while s<>"exit"

s=""

 s=getstr() 'read and ignore empty strings

'print "Information about the string:"
'print
'print "string: ";s
'print "length: ";len(s)


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
 a=strint(s)
 if strint_errors<>0 or len(s)=0 then
 'print s;" cannot be added to the stack because it is not a valid number"
 else
 csi+=1
 chastack(csi)=a
 print intstr(a);" was added to the stack"
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

