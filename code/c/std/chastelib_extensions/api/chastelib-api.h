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

int init_length=0x100; /*the default length for new integers allocated*/

/*
Arbitrary Precision Integer structure
*/
struct api_t
{
 char *digits;   /*pointer to an array of dynamically allocated of bytes*/
 int length,x;   /*current number of digits used*/
 int length_max; /*current number of digits used*/
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

void put_api(struct api_t *a)
{
 int x=a->length;
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
 while(x<b->length)
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
*/
int api_sub(struct api_t *a,struct api_t *b)
{
 int x=0,y=0;
 while(x<b->length)
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

 if(a->digits[x]!=0)
 {
  putstr("Warning: signbit changed to 1 for negative number.\n");
  a->signbit=1;
  return 1; /*an error has occurred*/
 }

 return 0; /*if no errors, return 0*/
}
