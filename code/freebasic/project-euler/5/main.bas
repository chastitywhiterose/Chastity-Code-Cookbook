dim as integer a,b,c

a=0
b=20
c=0

while a<=b

c+=1
'print c

a=2
while a<=b

if c mod a = 0 then
'print "a";a;" divides into ";c
else
exit while
end if

a+=1
wend

wend

print "c=";c

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
