DIM a AS INTEGER
DIM b AS INTEGER

radix = 16

a = 0
b = 128

WHILE a < b

PRINT a;

IF (a >= 32) AND (a <= 126) THEN
PRINT " " + CHR$(a);
END IF

PRINT

a = a + 1
WEND

' This is a QBASIC program.
' run it in the original QBASIC for DOS

