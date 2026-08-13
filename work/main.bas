DECLARE FUNCTION intstr$ (i AS INTEGER)
DECLARE FUNCTION strint (s AS string)


' global variables to define radix and formatting
' for the intstr function

DIM SHARED radix AS INTEGER
DIM SHARED intwidth AS INTEGER

radix = 2
intwidth = 1

' translation of intstr function for FreeBASIC
' by original C programmer Chastity White Rose

DIM a AS INTEGER
DIM b AS INTEGER

a = 0
b = 128

b=strint("101")

WHILE a < b

radix = 2
intwidth = 8
PRINT intstr$(a); " ";

radix = 16
intwidth = 2
PRINT intstr$(a); " ";

radix = 10
intwidth = 3
PRINT intstr$(a);

IF (a >= 32) AND (a <= 126) THEN
PRINT " " + CHR$(a);
END IF

PRINT

a = a + 1
WEND

' This is a QBASIC program.
' run it in the original QBASIC for DOS

FUNCTION intstr$ (i AS INTEGER)

 DIM s AS STRING
 DIM w AS INTEGER
 DIM c AS INTEGER
 DIM t AS INTEGER

 t = i
 s = ""
 w = 0

 WHILE i <> 0 OR w < intwidth
  c = i MOD radix
  i = i \ radix

  IF c < 10 THEN
  c = c + 48
  ELSE
  c = c + 55
  END IF

  s = CHR$(c) + s

  w = w + 1
 WEND

i = t
intstr = s
END FUNCTION


/'
 global variable for error detection in strint function
 this variable will be zero if last string was a number
'/
dim shared as integer strint_errors

/'
 translation of strint function for FreeBASIC
 by original C programmer Chastity White Rose
'/
function strint(s as string)
dim as integer i
dim as integer x,y
dim as integer c

i=0

strint_errors = 0 /' clear errors '/

x=0
y=len(s)
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
 /' whitespace '/
 elseif c >= 0 and c <= 32 then
  exit while /' exit correctly at string end '/
 else
  strint_errors+=1
  print "Error: ";chr$(s[x]);" is not an alphanumeric character!"
  exit while /' exit at invalid character '/
 end if

 if c>=radix then
  strint_errors+=1
  print "Error: ";chr$(s[x]);" is not a valid character for radix ";radix
  exit while /' exit at digit wrong for radix '/
 end if

 /'multiply by radix then add digit'/
 i*=radix
 i+=c

x+=1
wend

strint=i
end function

