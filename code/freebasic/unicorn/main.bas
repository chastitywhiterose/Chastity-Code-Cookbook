' fbc main.bas && main.exe
' array test
dim shared as integer unix,uniy,uniz,unicorn_length=16:
dim shared as byte unicorn(unicorn_length):

sub info

unix=0:
while(unix<unicorn_length)
 print "unicorn(";unix;"):",unicorn(unix):
 unix+=1:
wend

end sub

sub hello
 print "Hello World":
end sub

sub powers2tiny
 dim as ulongint x=1:
 while(x<>0)
  print x:
  x+=x:
 wend
end sub

sub powers2(byval a as integer)
 unix=0:
 while(unix<unicorn_length): unicorn(unix)=0: unix+=1: wend: unicorn(0)=1:
 uniy=1:
 uniz=0:
 while(uniz<=a)
  unix=uniy:
  print str(uniz);" ";: while(unix>0):  unix-=1: print str(unicorn(unix));: wend: print:
  unicorn(uniy)=0:
  unix=0:
  while(unix<uniy)
   unicorn(unix)*=2:
   unicorn(unix)+=unicorn(uniy):
   if(unicorn(unix)>=10)then: unicorn(uniy)=1: unicorn(unix)-=10: else: unicorn(uniy)=0: end if:
   unix+=1:
  wend
  if(unicorn(uniy)=1)then:uniy+=1:end if:
  uniz+=1:
 wend
end sub

sub main
 hello
 'powers2tiny
 powers2(64)
end sub

main