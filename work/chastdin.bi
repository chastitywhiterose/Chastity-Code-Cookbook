dim shared as string stdin_buf
dim shared as integer stdin_buf_index
dim shared as integer stdin_buf_length=0

function getstr() as string
dim as string s="new"
if stdin_buf_length=0 then
input "-> ",stdin_buf
stdin_buf_index=0
stdin_buf_length=len(stdin_buf)
end if
s=stdin_buf
return s
end function


function getline() as string
dim as string s=""
input "-> ",stdin_buf
s=stdin_buf
return s
end function
