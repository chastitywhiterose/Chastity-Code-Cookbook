/'
 global variables to define radix and formatting
 for the intstr function
'/
dim shared as integer radix=2
dim shared as integer int_width=1

/'
 translation of intstr function for FreeBASIC
 by original C programmer Chastity White Rose
'/
function intstr(i as uinteger) as string
 dim as string s=""
 dim as integer w=0
 dim as byte c

 while i<>0 or w<int_width 

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
b=256

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
print " "+chr$(a);
endif

print

a=a+1
wend

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
