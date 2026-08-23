#include "chastelib.bi"

dim filename as string="testfile.txt"
Dim f As Long 'the file handle

dim shared as ubyte bytedata(0 to 15)

dim as integer a,x,offset=0,count_read=1

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

radix=16

while count_read>0

'read from file #f into the bytedata array 16 byes, store amount read in count_read

get #f,,bytedata(),,count_read

'if count_read is 0, end this loop
if count_read=0 then
exit while
end if

'print 8 hex digit for the offset
int_width=8
print intstr(offset);" ";

int_width=2

x=0
while x<count_read
print intstr(bytedata(x));" ";
x+=1
wend

'after the previous loop, we will print the characters
'if they are valid printable characters in range
'otherwise replace them with dots
x=0
while x<count_read

a=bytedata(x)
if(a>=32) and (a<=126) then
print chr(a);
else
print ".";
endif
x+=1
wend
print





offset+=count_read

wend

' Close the file.
Close #f

print "EOF"

' End the program. (Check the file "file.ext" upon running to see the output.)
End
