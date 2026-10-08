/*
 This file is a C library of functions written by Chastity White Rose.
 This library is an extension of the original chastelib library.
 
 The purpose is to create and manage Arbitrary Precision Integers.
 These integers should be represented as strings of digits using the current radix.
*/

/*
 section zero

 these variables, types, and functions are concerned with creating
 a new api integer and setting its value with a regular integer
*/

/*
 the default length for new integers allocated
 can be increased by the main program to allocate more digits
*/
int init_length=0x100;

/*
Arbitrary Precision Integer structure
*/
struct api_t
{
 char *digits;   /*pointer to an array of dynamically allocated of bytes*/
 int length,x;   /*current number of digits used*/
 int length_max; /*maximum number of digits used*/
 int signbit;    /*used to fake negative numbers in subtraction*/
};

/*
 the following typedef is a convenience type
 so that a program can define variables as:

 api a,b;

 instead of:

 struct api_t *a,*b;

 It looks cleaner to a human but to the compiler
 the two statements are identical thanks to the name
 api being assigned to a pointer of type apt_t
*/
typedef struct api_t* api;

struct api_t* api_new()
{
 /*create a new pointer variable for an api struct*/
 struct api_t *a;
 /*allocate memory for the variables of this struct*/
 a=malloc(sizeof(*a));
 /*use default init_length*/
 a->length_max=init_length;
 /*allocate memory for the array of digits*/
 a->digits=malloc(a->length_max*sizeof(*a->digits));
 if(a->digits==NULL){printf("Failed to create digits array\n");}
 /*set length of used digits to 1*/
 a->length=1;
 /*set lowest digit to 0*/
 a->digits[0]=0;
 /*set signbit to 0 meaning positive or unsigned*/
 a->signbit=0;
 /*return this pointer to the calling function*/
 return a;
}

void api_delete(struct api_t *a)
{
 /*free the allocated digits array first*/
 free(a->digits);
 /*then free the structure itself*/
 free(a);
}

/*
 print all the digits of the api integer
 with a leading - if the signbit is set
*/
void put_api(struct api_t *a)
{
 int x;

 if(a->signbit)
 {
  putstr("-");
 }

 x=a->length;
 while(x>0)
 {
  x--;
  putint(a->digits[x]);
 }

}

void put_api_reverse(struct api_t *a)
{
 int x=0;
 while(x<a->length)
 {
  putint(a->digits[x]);
  x++;
 }
}


void api_set_ui(struct api_t *a,unsigned int i)
{
 int x=0;
 while(i!=0)
 {
  a->digits[x]=i%radix;
  i/=radix;
  x++;
 }
 if(x>a->length)
 {
  a->length=x;
 }
}





/*
 a=b
 x is used as index variable
 every digit in a is copied from b
 length of a is set to the length of b
*/
void api_mov(struct api_t *a,struct api_t *b)
{
 int x=0;
 while(x<b->length)
 {
  a->digits[x]=b->digits[x];
  x++;
 }
 a->length=b->length;
}



/*
 section 1

 these functions do arithmetic on the api variables
 and should only be used once they are initialized
*/


/*
 a=a+b
 x is used as index variable
 y is used as carry variable
*/
void api_add(struct api_t *a,struct api_t *b)
{
 int x=0,y=0;
 while(x<a->length)
 {
  y+=a->digits[x];
  y+=b->digits[x];
  a->digits[x]=y%radix;
  y/=radix;
  x++;
 }
 if(y)
 {
  a->digits[x]=y;
  a->length++;
 }
}





/*
 a=a-b
 x is used as index variable
 y is used as borrow variable
 this function fails miserably if you subtract
 a larger number from a smaller number
 negative numbers are not part of this library
 but are simulated with a signbit field in the api struct
*/
int api_sub(struct api_t *a,struct api_t *b)
{
 int x=0,y=0;
 api t; /*temporary variable in case something goes horribly wrong!*/
 t=api_new();  /*allocate temp int*/
 api_mov(t,a); /*make copy of a*/

 while(x<a->length)
 {
  y=a->digits[x]-y;
  y-=b->digits[x];

  /*printf("y=%d\n",y);*/
  /*if negative y, borrow from next digit*/
  if(y<0)
  {
   y+=radix;
   a->digits[x]=y;
   y=1;
  }
  else
  {
   a->digits[x]=y;
   y=0;
  }

  x++;
 }

 /*reduce length by excluding leading zero digits*/
 while(a->digits[x-1]==0 && x>1)
 {
  x--;
 }
 a->length=x;

 /*
  if b is greater than a, it results in negative number
  we subtract original a from b to get the difference
  and then flip the sign bit
 */
 if(y!=0)
 {
  putstr("Warning: signbit changed to 1 for negative number.\n");
  a->signbit=1;
  api_mov(a,b);
  api_sub(a,t);
 }

 api_delete(t);

 return a->signbit;
}








/*
 a=a*b
 each api integer has its own index variable
 i is used as product and carry variable
 c integer destination is dynamically created and 
 then copied to a and deleted
*/
void api_mul(struct api_t *a,struct api_t *b)
{
 int i,ax,bx,cx;

 api c; /*temporary variable in case something goes horribly wrong!*/
 c=api_new(); /*allocate temp int*/

 /*all digits of c must be initialized o 0*/
 cx=0;
 while(cx<c->length_max)
 {
  c->digits[cx]=0;
  cx++;
 }

 /*
  multiply the a and b arrays together and store the result
  in the c array
 */
  bx=0;
  while(bx<b->length)/*multiplication code begin*/
  {
   ax=0;
   while(ax<a->length)
   {
    i=a->digits[ax]*b->digits[bx];
    cx=ax+bx; 
    while(cx<c->length_max && i>0)
    {
     c->digits[cx]+=i;
     i=c->digits[cx]/radix;
     c->digits[cx]%=radix;
     cx++;
     if(cx>c->length){c->length=cx;}
    }
    ax++;
   }
   bx++;

  } /*multiplication code end*/

 api_mov(a,c);
 api_delete(c);
}

/*
 a is left shifted once
 this is the same as multiplying by the radix
 this is designed as a convenience function for
 the long division algorithm later
*/
void api_shl(struct api_t *a)
{
 int x=a->length;
 while(x>0)
 {
  x--;
  a->digits[x+1]=a->digits[x];
 }
 a->digits[x]=0;
 /*
  if the digit at length index is not zero
  then we expand this integer by 1 digit
 */
 if(a->digits[a->length]!=0)
 {
  a->length++;
 }
}


/*
 compares api integers a and b
 
 first it uses the length of the integers
 to see which is more or less than the other
 if both numbers are the same amount of digits
 then it compares them all high to low

 regardless of which branch executes:
 it returns the following regular int
 -1 if a is less than b
  0 if a is same as b
 +1 if a is more than b
*/
int api_cmp(struct api_t *a,struct api_t *b)
{
 int x=0,y;
 /*
  first use the length of used digits
  as a quick hack for finding which is
  more or less if they are different
 */
 if(a->length < b->length)
 {
  y=-1;
 }
 else if(a->length > b->length)
 {
  y=1;
 }
 /*
  if a and b have the same length
  check the high to low digits and then return
  based on any differences found
 */
 else
 {
  y=0;
  x=a->length;
  while(x>0)
  {
   x--;
   if(a->digits[x] < b->digits[x])
   {
    y=-1;
    break;
   }
   if(a->digits[x] > b->digits[x])
   {
    y=1;
    break;
   }
  }
 }
 return y;
}











void api_div(struct api_t *a,struct api_t *b)
{
 int x,ax,cmp;

 api q; /*quotient*/
 api r; /*remainder*/
 q=api_new(); /*allocate quotient*/
 r=api_new(); /*allocate remainder*/


 /*all digits of q and r must be initialized o 0*/
 x=0;
 while(x<q->length_max)
 {
  q->digits[x]=0;
  r->digits[x]=0;
  x++;
 }

 /*
  divide b from a
  store the quotient in q
  and remainder in r
 */
  ax=a->length;
  while(ax>0) /*division code begin*/
  {
   ax--;
 
   /*
    left shift remainder by radix
    and place next digit from a
    as lowest digit of remainder
   */
   api_shl(r);
   r->digits[0]=a->digits[ax];

   x=0; /*used to be next quotient digit*/
   /*
    while the remainder is greater or equal to b
    subtract b from r
    keep track of how many times with i
   */
   while(1)
   {

    putstr("r==");
    put_api(r);
    putstr("\nb==");
    put_api(b);
    putstr("\n");
    cmp=api_cmp(r,b);
    printf("cmp==%d\n",cmp);
    if(cmp==-1)
    {
     printf("r is less than b: cannot subtract\n\n");
     break;
    }

    api_sub(r,b);
    put_api(r);
    putstr("\n");

    x++;
   }
   /*
    left shift quotient by radix
    and place next digit from i
    as lowest digit of quotient
   */
   api_shl(q);
   q->digits[0]=x;
 
  } /*division code end*/

 api_mov(a,q);
 api_delete(q);
 api_delete(r);
}