program hexadecimal;

var
 name:string;
 x:integer;
 y:integer;

begin
 name:='Chastity';
 x:=0;
 y:=16;

 while x<y do
 begin
 write('decimal ',x);
//  WriteLn('name=',name,' age=',age,' year=',year);

  // start of hex section
  i:=x;



 //*s=i%radix;
 // i/=radix;
 // if(*s<10){*s+='0';}
 // else{*s=*s+'A'-10;}


  writeln();
  x:=x+1;
 end;

end.

(*
 fpc main.pas && ./main
*)
