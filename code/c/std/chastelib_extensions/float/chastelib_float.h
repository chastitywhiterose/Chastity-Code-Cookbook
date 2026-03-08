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
 /*set the pointer to the approximate middle of the array*/
 char *s=float_string+fsl/2;
 char *sf=s; /*make a copy of this pointer for later use*/

 int width=0; /*width of integer part of the float*/
 int i=f; /*get integer portion of the float by implicit cast*/

 f-=i; /*subtract this integer portion from the original float*/

 /*
  first convert the integer portion of the float into a string
  using the exact same algorithm as the intstr function
 */
 *s=0;
 while(i!=0 || width<int_width)
 {
  s--;
  *s=i%radix;
  i/=radix;
  if(*s<10){*s+='0';}
  else{*s=*s+'A'-10;}
  width++;
 }
 
 if(f==0)
 {
  return s; /* if fractional part is zero, return only the int part of string*/
 }

*sf='.'; /*replace that zero from earlier with our "point"*/
sf++; /* go to the right one place from the point*/
width=0; /*the width variable is now repurposed for the float loop*/

 /*while the float part is not zero, we multiply by the base and extract the digits one at a time*/
 while(width<float_width)
 {
  f*=radix; /*multiply the float by radix*/
  i=f; /*cast the float to an int again*/
  f-=i; /*subtract this int from the float again*/
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


