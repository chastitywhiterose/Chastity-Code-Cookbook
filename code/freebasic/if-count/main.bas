dim as integer a,b,c
a=0
b=16
c=8

while a<b

if a<c then
print str(a)+" is less than "+str(c)
end if

if a=c then
print str(a)+" is equal to "+str(c)
end if

if a>c then
print str(a)+" is more than "+str(c)
end if

a+=1
wend

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
