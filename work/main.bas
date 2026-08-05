#include "chastelib.bi"

dim as integer a,b,c
a=0
b=256

dim as string t

radix=10

t="497B8"

b=strint(t)

print "b=";b
end

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

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
