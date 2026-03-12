//C++ header for 2.3 - Lab: Helper Library
namespace Helper
{

/*
 These two lines define a global array with a size big enough to store the digits of an integer, including padding it with extra zeroes.
 The integer conversion function always references a pointer to this global string, and this allows other standard library functions
 such as printf to display the integers to standard output or even possibly to files.
*/

const int usl = 32; /*usl stands for Unsigned String Length*/
char int_string[usl+1]; /*global string which will be used to store string of integers. Size is usl+1 for terminating zero*/

/*
This function is one that I wrote because the standard library can display integers as decimal, octal, or hexadecimal, but not any other bases(including binary, which is my favorite).
My function corrects this, and in my opinion, such a function should have been part of the standard library, but I'm not complaining because now I have my own, which I can use forever!
More importantly, it can be adapted for any programming language in the world if I learn the basics of that language.
*/

static char* intstr(unsigned int i, int radix = 10, int int_width = 1)
{
	int width = 0;
	char* s = int_string + usl;
	*s = 0;
	while (i != 0 || width < int_width)
	{
		s--;
		*s = i % radix;
		i /= radix;
		if (*s < 10) { *s += '0'; }
		else { *s = *s + 'A' - 10; }
		width++;
	}
	return s;
}

/*
 This function is my own replacement for the strtol function from the C standard library.
 I didn't technically need to make this function because the functions from stdlib.h can already convert strings from bases 2 to 36 into integers.
 However, my function is simpler because it only requires 2 arguments instead of three, and it also does not handle negative numbers.
I have never needed negative integers, but if I ever do, I can use the standard functions or write my own in the future.
*/

int strint_errors=0; //keep track of how many errors happened in the strint function
//invalid characters or an invalid radix would count as errors

static int strint(const char* s, int radix = 10)
{
	int i = 0;
	char c;
	strint_errors = 0; //set zero errors before we parse the string
	if (radix < 2 || radix>36) { strint_errors++; printf("Error: radix %i is out of range!\n", radix); }
	while (*s == ' ' || *s == '\n' || *s == '\t') { s++; } /*skip whitespace at beginning*/
	while (*s != 0)
	{
		c = *s;
		if (c >= '0' && c <= '9') { c -= '0'; }
		else if (c >= 'A' && c <= 'Z') { c -= 'A'; c += 10; }
		else if (c >= 'a' && c <= 'z') { c -= 'a'; c += 10; }
		else if (c == ' ' || c == '\n' || c == '\t') { break; }
		else { strint_errors++; printf("Error: %c is not an alphanumeric character!\n", c); break; }
		if (c >= radix) { strint_errors++; printf("Error: %c is not a valid character for radix %i\n", *s, radix); break; }
		i *= radix;
		i += c;
		s++;
	}
	return i;
}


//Calls strint and checks the number of errors produced
//If there are zero errors, it returns true

static bool IsInteger(const char* s)
{
	bool valid_int = false;
	strint(s,10);
	//std::cout << "errors:" << strint_errors << "\n";
	if (strint_errors == 0) { valid_int = true; }
	return valid_int;
}


//takes a pointer to an integer and prints all 32 bits in binary
static void PrintIntegerBinary(int* num)
{
	std::cout << intstr(*num, 2, 32); //call intstr to handle all details!
}

//takes a pointer to an integer and prints all 8 hex digits for the 32 bit int
static void PrintIntegerHex(int* num)
{
	std::cout << intstr(*num, 16, 8); //call intstr to handle all details!
}

//takes a pointer to an integer and prints the octal / base 8 form
static void PrintIntegerOct(int* num)
{
	std::cout << intstr(*num, 8, 1); //call intstr to handle all details!
}

/*
 Description: Implements the bubble sort algorithm to sort an array of integers.
 It should take the array and its size as parameters and sort the array in ascending order.
*/

static void BubbleSort(int* a, int size)
{
	bool swapped; //declare the bool so that it exists later
	int n = size - 1;
	do
	{
		swapped = false;
		for (int i = 1; i <= n - 1; i++)
		{
			if (a[i - 1] > a[i])
			{
				std::swap(a[i - 1], a[i]);
				swapped = true;
			}
		}
		n--;
	} while(swapped);
}




}

//2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61