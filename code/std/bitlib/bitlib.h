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
this division function returns the quotient, but also stores the remainder of division in a global variable
*/

int mod=0; /*the modulus/remainder of the division*/

int bitdiv(int di,int si)
{
 int ax=0,bx=si;

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



/*
function divide(dividend, divisor):
  if divisor == 0:
    // Handle division by zero error
  
  quotient = 0
  temp_divisor = divisor
  
  // Align divisor with dividend by shifting
  while temp_divisor <= dividend:
    temp_divisor = temp_divisor << 1
  
  while temp_divisor > divisor:
    temp_divisor = temp_divisor >> 1
    quotient = quotient << 1
    if dividend >= temp_divisor:
      dividend = subtract(dividend, temp_divisor)
      quotient = add(quotient, 1)
  return quotient
*/