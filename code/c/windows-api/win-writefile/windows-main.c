#include <windows.h>
int main()
{
	HANDLE StdOut;
	HANDLE hFile;
    DWORD bytesWritten;
    char data0[] = "Hello, world!";
    char data1[] = "This text is written to file!";
    char data_error_open[]="Error opening file\n";
    char data_error_write[]="Error writing to file\n";
    
    StdOut = GetStdHandle(STD_OUTPUT_HANDLE);
	WriteFile(StdOut, data0, sizeof(data0), NULL, NULL);
	
	hFile = CreateFile("myfile.txt", GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
    {
        WriteFile(StdOut, data_error_open, sizeof(data_error_open), NULL, NULL);
		return 1;
    }

    if(!WriteFile(hFile, data1, sizeof(data1), &bytesWritten, NULL))
    {
        WriteFile(StdOut,data_error_write, sizeof(data_error_write), NULL, NULL);
        return 1;
    }

    CloseHandle(hFile);
	
	ExitProcess(ERROR_SUCCESS);
}

/*
 This is a Windows API Console example. I have tested and confirm that it works in Visual Studio and also GCC.
 There is no benefit to using the Windows API over the standard C library functions.
 Except there is a small chance it might be faster. More testing is needed.

 gcc -Wall -ansi -pedantic windows-main.c -o windows-main && windows-main
*/
