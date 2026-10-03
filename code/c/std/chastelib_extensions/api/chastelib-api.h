/*
 This file is a C library of functions written by Chastity White Rose.
 This library is an extension of the original chastelib library.
 
 The purpose is to create and manage Arbitrary Precision Integers.
 These integers should be represented as strings of digits using the current radix.
*/

int init_length=0x100; /*the default length for new integers allocated*/

/*
Arbitrary Precision Integer structure
*/
struct api
{
 char *digits; /*pointer to an array of dynamically allocated of bytes*/
 int length,x;  /*current number of digits used*/
 int length_max;  /*current number of digits used*/
};

struct api* api_new()
{
 /*create a new pointer variable for an api struct*/
 struct api *a;
 /*allocate memory for the variables of this struct*/
 a=malloc(sizeof(*a));
 /*use default init_length*/
 a->length_max=init_length;
 /*allocate memory for the array of digits*/
 a->digits=malloc(sizeof(*a->digits));
 /*set length of used digits to 1*/
 a->length=1;
 /*set lowest digit to 0*/
 a->digits[0]=0;
 /*return this pointer to the calling function*/
 return a;
}

void put_api(struct api *a)
{
 int x=0;
 while(x<a->length)
 {
  putint(a->digits[x]);
  x++;
 }
}
