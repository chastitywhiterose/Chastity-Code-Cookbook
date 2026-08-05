/'
this is an early prototype of the intstr function for FreeBASIC
'/
dim shared as integer radix=2
dim shared as integer int_width=1

function intstr(i as integer) as string
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

dim shared as integer strint_errors=0

function strint(s as string) as integer
dim as integer i=0
dim as integer x=0,y=len(s)
dim as byte c

while x<y

 /' read digit from string '/
 c=s[x]

 /' 0 to 9 '/
 if c >= 48 and c <= 57 then
 c-=48
 /' A to Z '/
 elseif c >= 65 and c <= 90 then
 c-=65
 c+=10
 /' a to z '/
 elseif c >= 97 and c <= 122 then
 c-=97
 c+=10
 end if

 /'multiply by radix then add digit'/
 i*=radix
 i+=c

x+=1
wend

return i
end function
