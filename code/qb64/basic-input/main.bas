Dim As Integer a
Dim As String s

Print "Welcome to the BASIC input program!"
Print "This program asks for a string from the user and shows information."
Print "It ends as soon as the string is "; "exit"; "."
Print

While s <> "exit"

    Input "enter a string from the keyboard: ", s

    Print "Information about the string:"
    Print
    Print "string: "; s
    Print "length: "; Len(s)

Wend

' This is a QBASIC64 program.
'
' compile and run as:
'
' fbc main.bas && ./main


