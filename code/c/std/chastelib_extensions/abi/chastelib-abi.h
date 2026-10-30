/*
 This file is a C library of functions written by Chastity White Rose.
 This library is an extension of the original chastelib library.
 
 The purpose is to create and manage Arbitrary Precision Integers.
 These integers should be represented as strings of bits using the current radix.
*/

/*
 section zero

 these variables, types, and functions are concerned with creating
 a new api integer and setting its value with a regular integer
*/

/*
 the default length for new integers allocated
 can be increased by the main program to allocate more bits
*/
int init_length=0x10;

/*
Arbitrary Precision Integer structure
*/
struct abi_t
{
 char *bits;   /*pointer to an array of dynamically allocated of bytes*/
 int length;   /*current number of bits used*/
 int length_max; /*maximum number of bits used*/
};

/*
 the following typedef is a convenience type
 so that a program can define variables as:

 api a,b;

 instead of:

 struct abi_t *a,*b;

 It looks cleaner to a human but to the compiler
 the two statements are identical thanks to the name
 api being assigned to a pointer of type apt_t
*/
typedef struct abi_t* abi;

struct abi_t* abi_new()
{
 /*create a new pointer variable for an api struct*/
 struct abi_t *a;
 /*allocate memory for the variables of this struct*/
 a=malloc(sizeof(*a));
 /*use default init_length*/
 a->length_max=init_length;
 /*allocate memory for the array of bits*/
 a->bits=malloc(a->length_max*sizeof(*a->bits));
 if(a->bits==NULL){printf("Failed to create bits array\n");}
 /*set length of used bits to 1*/
 a->length=1;
 /*set lowest digit to 0*/
 a->bits[0]=0;
 /*return this pointer to the calling function*/
 return a;
}

void abi_delete(struct abi_t *a)
{
 /*free the allocated bits array first*/
 free(a->bits);
 /*then free the structure itself*/
 free(a);
}

/*
 print all the bits of the api integer
 with a leading - if the signbit is set
*/
void put_abi(struct abi_t *a)
{
 int x;
 x=a->length;
 while(x>0)
 {
  x--;
  putint(a->bits[x]);
 }
}

void put_abi_all(struct abi_t *a)
{
 int x;
 x=a->length_max;
 while(x>0)
 {
  x--;
  putint(a->bits[x]);
 }
}


void abi_set_ui(struct abi_t *a,unsigned int i)
{
 int x=0;
 while(i!=0)
 {
  a->bits[x]=i&1;
  i>>=1;
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
void abi_mov(struct abi_t *a,struct abi_t *b)
{
 int x=0;
 while(x<b->length)
 {
  a->bits[x]=b->bits[x];
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
not fixed yet
 a=a+b
 x is used as index variable
 y is used as carry variable
*/
void abi_add(struct abi_t *a,struct abi_t *b)
{
 int x=0,y=0,y1;
 while(x<a->length_max)
 {
  y1=a->bits[x];
  a->bits[x]^=b->bits[x];
  a->bits[x]^=y;
  y=y1&=b->bits[x];
  x++;
 }
}


