DECLARE FUNCTION intstr$ (i AS INTEGER)
DECLARE FUNCTION strint (s AS STRING)


' global variables to define radix and formatting
' for the intstr function

Dim Shared radix As Integer
Dim Shared intwidth As Integer

radix = 2
intwidth = 1

' translation of intstr function for FreeBASIC
' by original C programmer Chastity White Rose

Dim a As Integer
Dim b As Integer

a = 0
b = strint("100000000")

While a < b

    radix = 2
    intwidth = 8
    Print intstr$(a); " ";

    radix = 16
    intwidth = 2
    Print intstr$(a); " ";

    radix = 10
    intwidth = 3
    Print intstr$(a);

    If (a >= 32) And (a <= 126) Then
        Print " " + Chr$(a);
    End If

    Print

    a = a + 1
Wend

' This is a QBASIC program.
' You can run it in the original QBASIC for DOS

' It has also been tested in both QB64 and FreeBASIC with "-lang qb" option.

'

' global variable for error detection in strint function
' this variable will be zero if last string was a number

Dim Shared strinterror As Integer

' translation of strint function for FreeBASIC
' by original C programmer Chastity White Rose

Function intstr$ (i As Integer)

    Dim s As String
    Dim w As Integer
    Dim c As Integer
    Dim t As Integer

    t = i
    s = ""
    w = 0

    While i <> 0 Or w < intwidth
        c = i Mod radix
        i = i \ radix

        If c < 10 Then
            c = c + 48
        Else
            c = c + 55
        End If

        s = Chr$(c) + s

        w = w + 1
    Wend

    i = t
    intstr = s
End Function

'/
Function strint (s As String)
    Dim i As Integer
    Dim x, y As Integer
    Dim c, c1 As Integer


    i = 0

    strinterror = 0

    x = 0
    y = Len(s)
    While x < y

        ' read digit from string
        c = Asc(Mid$(s, x + 1, 1))
        c1 = c 'a second copy for printing error messages

        ' 0 to 9
        If c >= 48 And c <= 57 Then
            c = c - 48
            ' A to Z
        ElseIf c >= 65 And c <= 90 Then
            c = c - 65
            c = c + 10
            ' a to z
        ElseIf c >= 97 And c <= 122 Then
            c = c - 97
            c = c + 10
            ' whitespace
        ElseIf c >= 0 And c <= 32 Then
            x = y
        Else
            strinterror = strinterror + 1
            Print "Error: "; Chr$(c1); " is not an alphanumeric character!"
        End If

        If c >= radix Then
            strinterror = strinterror + 1
            Print "Error: "; Chr$(c1); " is not a valid character for radix "; radix
        End If

        'multiply by radix then add digit
        i = i * radix
        i = i + c

        x = x + 1
    Wend

    strint = i
End Function

