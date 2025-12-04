/*bitlib.h*/

int add(int di,int si)
{
 while(si!=0)
 {
  int ax=di;
  di^=si;
  si&=ax;
  si<<=1;
 }
 return di;
}


int sub(int di,int si)
{
 while(si!=0)
 {
  di^=si;
  si&=di;
  si<<=1;
 }
 return di;
}



int mul(int di,int si)
{
 int ax=0;
 while(si!=0)
 {
  if((si&1)!=0){ax=add(ax,di);}
  di<<=1;
  si>>=1;
 }
 return ax;
}



/*
function multiply(a, b):
  result = 0
  while b != 0:
    if (b & 1) != 0: // If the rightmost bit of b is 1
      result = add(result, a) // Add a to the result
    a = a << 1 // Left shift a
    b = b >> 1 // Right shift b
  return result

*/