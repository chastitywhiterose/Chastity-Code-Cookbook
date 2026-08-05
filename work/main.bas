/'
this is an early prototype of the intstr function for FreeBASIC
'/

function intstr(i as integer) as string
dim as string s="dudeman"



return s
end function


dim as integer a,b,c
a=0
b=16
c=8

while a<b

print intstr(a)

a+=1
wend

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
