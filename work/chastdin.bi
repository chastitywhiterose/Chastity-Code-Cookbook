dim shared as string stdin_buf
dim shared as integer stdin_buf_index
dim shared as integer stdin_buf_length=0

function getstr() as string
dim as string s=""         'create empty string
dim as byte c              'temporary byte/char variable
if stdin_buf_length=0 then 'check if there are characters in the buf
input "-> ",stdin_buf      'if not, read a line of text
stdin_buf_index=0          'set index to zero
stdin_buf_length=len(stdin_buf)
end if

while stdin_buf_index<stdin_buf_length
c=stdin_buf[stdin_buf_index]
if(c>=32) and (c<=126) then
'print " "+chr(c);
s=s+chr(c)
endif
wend

return s
end function


function getline() as string
dim as string s=""
input "-> ",stdin_buf
s=stdin_buf
return s
end function
