DECLARE FUNCTION intstr$ (i AS INTEGER)

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

