dim as integer a,b,c,d

a=1
b=1
d=0

while a<=4000000

if a mod 2 = 0  then
c=a
else
c=0
end if
d+=c

'print a

c=a+b
a=b
b=c

a+=1
wend

print d

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
