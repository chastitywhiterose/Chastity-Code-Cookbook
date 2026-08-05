/'
this is an early prototype of the intstr function for FreeBASIC
'/
dim shared as integer radix=2
dim shared as integer int_width=6


function intstr(i as integer) as string
dim as string s="dudeman"
dim as integer w=0
dim as byte c



 while i<>0 or w < int_width 
                      
  c=i mod radix                  
  i/=radix                     
'  if(*s<10){*s+='0';}           
'  else{*s=*s+'A'-10;}           
  w+=1                     
 wend

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
