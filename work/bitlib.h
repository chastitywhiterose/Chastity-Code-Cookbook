/*bitlib.h*/

typedef int64_t integer;

integer add(integer di,integer si)
{
 while(si!=0)
 {
  integer ax=di;
  di^=si;
  si&=ax;
  si<<=1;
 }
 return di;
}


integer sub(integer di,integer si)
{
 while(si!=0)
 {
  di^=si;
  si&=di;
  si<<=1;
 }
 return di;
}



integer mul(integer di,integer si)
{
 integer ax=0;
 while(si!=0)
 {
  if((si&1)!=0){ax=add(ax,di);}
  di<<=1;
  si>>=1;
 }
 return ax;
}


/*
this division function returns the quotient, but also stores the remainder of division in a global variable
*/

integer mod=0; /*the modulus/remainder of the division*/

integer bitdiv(integer di,integer si)
{
 integer ax=0,bx=si;

 if(si==0){return 0;} /*division by zero is invalid*/

 while(bx<=di)
 {
  bx<<=1;
 }

 while(bx>si)
 {
  bx>>=1;
  ax<<=1;
  if(di>=bx){di=sub(di,bx);ax=add(ax,1);}
 }

 mod=di;
 return ax;
}


