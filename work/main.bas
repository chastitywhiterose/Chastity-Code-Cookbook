DECLARE FUNCTION intstr$ (i AS INTEGER)
DECLARE FUNCTION strint (s AS STRING)

' global variables to define radix and formatting
' for the intstr function

DIM SHARED radix AS INTEGER
DIM SHARED intwidth AS INTEGER

radix = 2
intwidth = 1

DIM a AS INTEGER
DIM b AS INTEGER

a = 0
b = strint("100000000")

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
' You can run it in the original QBASIC for DOS

' It has also been tested in FreeBASIC with "-lang qb" option.

' Chastity's two supreme functions are defined below.
' Both of them operate using the shared global radix variable

' intstr converts an integer to a string
' strint converts a string to an integer

' translation of strint function for FreeBASIC
' by original C programmer Chastity White Rose

' global variable for error detection in strint function
' this variable will be zero if last string was a number

DIM SHARED strinterror AS INTEGER

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

FUNCTION strint (s AS STRING)
    DIM i AS INTEGER
    DIM x, y AS INTEGER
    DIM c, c1 AS INTEGER


    i = 0

    strinterror = 0

    x = 0
    y = LEN(s)
    WHILE x < y

        ' read digit from string
        c = ASC(MID$(s, x + 1, 1))
        c1 = c 'a second copy for printing error messages

        ' 0 to 9
        IF c >= 48 AND c <= 57 THEN
            c = c - 48
            ' A to Z
        ELSEIF c >= 65 AND c <= 90 THEN
            c = c - 65
            c = c + 10
            ' a to z
        ELSEIF c >= 97 AND c <= 122 THEN
            c = c - 97
            c = c + 10
            ' whitespace
        ELSEIF c >= 0 AND c <= 32 THEN
            x = y
        ELSE
            strinterror = strinterror + 1
            PRINT "Error: "; CHR$(c1); " is not an alphanumeric character!"
        END IF

        IF c >= radix THEN
            strinterror = strinterror + 1
            PRINT "Error: "; CHR$(c1); " is not a valid character for radix "; radix
        END IF

        'multiply by radix then add digit
        i = i * radix
        i = i + c

        x = x + 1
    WEND

    strint = i
END FUNCTION

