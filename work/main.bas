/'
this is an early prototype of the intstr function for FreeBASIC
'/
dim shared as integer radix=10
dim shared as integer int_width=1


function intstr(i as integer) as string
dim as string s=""
dim as integer w=0
dim as byte c

print i

 while i<>0 or w < int_width 
                      
  c=i mod radix                  
  i\=radix                     

  if c<10 then 
  c+=48
  else
  c+=55
  end if
  s=chr(c)+s

  w+=1                     
 wend

return s
end function


dim as integer a,b,c
a=0
b=16
c=8

radix=16

while a<b

print intstr(a)

a+=1
wend

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
