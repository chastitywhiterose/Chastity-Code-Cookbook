program life;

var
 name:string;
 year:integer;
 age:integer;

begin
 name:='Chastity';
 year:=1987;
 age:=0;

 while year<=2026 do
 begin
  WriteLn('name=',name,' age=',age,' year=',year);
  year:=year+1;
  age:=age+1;
 end;

end.

(*
 fpc main.pas && ./main
*)
