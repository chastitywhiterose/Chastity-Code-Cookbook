#include <windows.h>
int main()
{
	HANDLE StdOut = GetStdHandle(STD_OUTPUT_HANDLE);
	WriteFile(StdOut, "Hello World!\n", 13, NULL, NULL);
	ExitProcess(ERROR_SUCCESS);
}

/*
 This is a Windows API Console example. I have tested and confirm that it works in Visual Studio and also GCC.
 There is no benefit to using the Windows API over the standard C library functions.
 Except there is a small chance it might be faster. More testing is needed.

 gcc -Wall -ansi -pedantic windows-main.c -o windows-main && windows-main
*/
