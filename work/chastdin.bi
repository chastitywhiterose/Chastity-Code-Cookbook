dim shared as string stdin_buf
dim shared as integer stdin_buf_index
dim shared as integer stdin_buf_length=0

function getstr() as string
dim as string s=""         'create empty string
dim as byte c              'temporary byte/char variable

/'
this section gets a line of text
if the length of the string/buffer is 0
'/

if stdin_buf_length=0 then      'check if there are characters in the buf
input "-> ",stdin_buf           'if not, read a line of text
stdin_buf_index=0               'set index to zero
stdin_buf_length=len(stdin_buf) 'set the length
end if

/'
regardless of whether input was added above
or if it still had bytes from the last input
we then extract characters one at a time into the
substring s to be returned from the function
'/

while stdin_buf_index<stdin_buf_length
c=stdin_buf[stdin_buf_index]
stdin_buf_index+=1
if(c>=33) and (c<=126) then
s=s+chr(c)
else
exit while
endif
wend

/'
if the index matches the length of buffer
set length to zero so that more will be read
next time this function is called
'/

if stdin_buf_index=stdin_buf_length then
stdin_buf_length=0
end if

return s
end function

/'
the getline function always gets an entire line of text
I don't really need it but it is here as a reminder of
how to use the input statement in FreeBASIC
'/

function getline() as string
dim as string s=""
input "-> ",stdin_buf
s=stdin_buf
return s
end function
