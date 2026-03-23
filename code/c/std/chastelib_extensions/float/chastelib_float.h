/* chastelib float extension */

/*
 These two lines define a static array with a size big enough to store the digits of an floating point number.
 The fltstr conversion function always references a pointer to this global string, and this allows other standard library functions
 such as printf to display the numbers to standard output or even possibly to files.
*/

#define fsl 0x100 /*fsl stands for Float String Length*/
char float_string[fsl+1]; /*global string which will be used to store string of float conversion. Size is usl+1 for terminating zero*/

/*exact number of digits after the dot for printing floats using fltstr function*/
int float_width=1;

/*
This function can print floats almost the same as what printf can do.
 It uses the same radix and width variables as the integer conversion functions.
*/

char *fltstr(float f)
{
 int i; /*this will be used later as temporary integer*/
 int width=0; /*width of integer part of the float*/
 /*set the pointer to the approximate middle of the array*/
 char *s=float_string+fsl/2;
 char *sf=s; /*make a copy of this pointer for later use*/
 
 /*split the integer and fractional parts of the float*/
 float f_left=floor(f); /*everything left of the point*/
 float f_right=f-f_left; /*everything right of the point*/

 /*use printf only during debugging phase*/
 printf("f_left=%f\n",f_left);
 printf("f_right=%f\n",f_right);

 /*
  first convert the integer portion of the float into a string
  using the exact same algorithm as the intstr function
 */
 
 *s=0; /*for now, put a terminating zero at end of integer string*/
 while(f_left!=0 || width<int_width)
 {
  s--;
  f=fmod(f_left,radix); /*use fmod to get the remainder of division by radix*/
  f_left=floor(f_left/radix); /*divide f_left by radix but floor it to keep as integer*/
  printf("fmod=%f ",f); printf("f_left=%f\n",f_left);
  i=f; /*cast remainder in f to int variable*/
  *s=i;
  if(*s<10){*s+='0';}
  else{*s=*s+'A'-10;}
  width++;
 }
 
 if(f_right==0)
 {
  return s; /* if fractional part is zero, return only the integer part of string*/
 }

*sf='.'; /*replace that zero from earlier with our "point"*/
sf++; /* go to the right one place from the point*/
width=0; /*the width variable is now repurposed for the float loop*/

 /*while the float part is not zero, we multiply by the base and extract the digits one at a time*/
 while(width<float_width)
 {
  f_right*=radix; /*multiply the right/fractional part of float by radix*/
  f=floor(f_right);
  f_right-=f; /*subtract this floored int from the right part*/

  i=f; /*cast the float to an int again*/
  *sf=i; /*the i integer will always be in the range of a digit in current radix*/
  if(*sf<10){*sf+='0';}
  else{*sf=*sf+'A'-10;}
  sf++; /*going to the right of the point*/
  width++;
 }

*sf=0; /*terminate the end of the float part string with a zero */
 
 return s;
}

/*
 This function uses both fltstr and putstring to print a float in the currently selected radix and width.
*/

void putflt(float f)
{
 putstring(fltstr(f));
}


