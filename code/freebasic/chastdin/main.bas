#include "chastelib.bi"
#include "chastdin.bi"

dim shared as integer chastack(256)
dim shared as integer csi=0 'Chastity's Stack Index

radix=10

dim as integer a,b
dim shared as string s

sub help()
?  "chastdin is a stack based interactive calculator"
?  "Numbers are pushed on the stack and commands can do math."
?  "It is a fork of chastack that reads from stdin instead of arguments."
?  "Each line can contain multiple numbers or commands."
?
?  "Math commands are add,sub,mul,div,rem"
?  "And use the top two stack numbers for their operations"
?
?  "The setradix command uses the top of stack as the new radix"
?  "The exit command ends the program"
?  "The ? command prints the entire stack"
?
end sub

sub stack_check()
 if csi>0 then
  chastack(csi+1)=0 /'erase old top of stack because command was successful'/
 else
  print "Error: two numbers required for command: ";s
  csi+=1 /'increment the pointer to what it was before the failed command'/
 end if
end sub

help():

while s<>"exit"

s=""

 s=getstr() 'read and ignore empty strings

'print entire stack
if s="?" or s="print" then
 b=csi
 while csi>0
  print intstr(chastack(csi))
  csi-=1
 wend
 csi=b

elseif s="exit" then
exit while

elseif s="help" then
help()

elseif s="setradix" then
 if csi>0 then
 radix=chastack(csi)
 chastack(csi)=0
 csi-=1
 else
  print "Error: need one number on stack for command: ";s
 end if

elseif s="add" then
b=chastack(csi)
csi-=1
a=chastack(csi)
a+=b
chastack(csi)=a
stack_check()

elseif s="sub" then
b=chastack(csi)
csi-=1
a=chastack(csi)
a-=b
chastack(csi)=a
stack_check()

elseif s="mul" then
b=chastack(csi)
csi-=1
a=chastack(csi)
a*=b
chastack(csi)=a
stack_check()

elseif s="div" then
b=chastack(csi)
csi-=1
a=chastack(csi)
a\=b
chastack(csi)=a
stack_check()

elseif s="rem" then
b=chastack(csi)
csi-=1
a=chastack(csi)
a=a mod b
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

wend

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/

