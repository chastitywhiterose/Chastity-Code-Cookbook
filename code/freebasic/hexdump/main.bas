' Create a string and fill it.
Dim buffer As String, f As Long
dim filename as string="testfile.txt"
buffer = "Hello World within a file."

dim shared as ubyte bytedata(16)
dim count_read as integer=1

' Find the first free file number.
f = FreeFile

' Open the file "file.ext" for binary usage, using the file number "f".
Open filename For Binary access read as #f
If Err>0 Then
 Print "Error opening the file "; filename
 End
else
print filename; " is open for reading"
end if

get #f,,bytedata()



' Place our string inside the file, using file number "f".
'Put #f, , buffer

' Close the file.
Close #f

' End the program. (Check the file "file.ext" upon running to see the output.)
End
