/*
 This file is a C library of functions written by Chastity White Rose.
 This library is an extension of the original chastelib library.
 
 The purpose is to create and manage Arbitrary Precision Integers. These integers should be represented as strings of digits using the current radix.
*/

/*
Arbitrary Precision Integer structure
*/
struct chaste_font
{
 char *digits /*pointer to an array of dynamically allocated of bytes*/
 int length;  /*current number of digits used*/
 int length_max=66;  /*current number of digits used*/
};

void api_init()
{
}
