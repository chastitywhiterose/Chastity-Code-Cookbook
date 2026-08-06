dim as integer a,b,c,d

a=1
b=1000
d=0

while a<b

if a mod 3 = 0 or a mod 5 = 0 then
c=a
else
c=0
end if
d+=c

'print a;" ";c;" ";d

a+=1
wend

print d

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
