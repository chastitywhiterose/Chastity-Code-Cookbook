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

int sign_bit=1<<((sizeof(int)<<3)-1);

int mod=0; /*the modulus/remainder of the division*/

int bitdiv(int di,int si)
{
 int ax=0,bx=0,cx=1;
 if(si==0){return 0;} /*division by zero is invalid*/

 while(cx!=0)
 {
  ax<<=1;
  bx<<=1;
  if(di&sign_bit){bx|=1;}
  di<<=1;
  
  if(bx>=si)
  {
   bx=sub(bx,si);ax|=1;
  }
 
  cx<<=1;
 }

 mod=bx;
 return ax;
}



