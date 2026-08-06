dim as integer a,b,c,d

a=1
b=936000
d=0

while a<=b

if a and 1 then
c=a*a
else
c=0
end if
d+=c

'print a;" ";c;" ";d

a+=1
wend

print d

/'

Problem Zero (https://projecteuler.net/) 8-6-2026

A number is a perfect square, or a square number, if it is the square of a positive integer.
For example, 25 is a square number because 5x5=25 ; it is also an odd square.

The first 5 square numbers are: 1,4,9,16,25, and the sum of the odd squares is 1+9+25=35.

Among the first 936 thousand square numbers, what is the sum of all the odd squares?

'/

/'
 This is a FreeBASIC program.

 compile and run as:

 fbc main.bas && ./main
'/
