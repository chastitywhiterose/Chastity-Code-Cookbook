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

void api_init(struct api *a)
{
 a->length_max=init_length;
 a->digits=malloc(a->length_max);
 a->length=1;
}
