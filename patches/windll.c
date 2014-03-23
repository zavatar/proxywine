#include <stdio.h>
#include <windows.h>

__declspec(dllexport) void __cdecl windll(void)
{
	LARGE_INTEGER frequency, t1, t2;
	QueryPerformanceFrequency(&frequency);
	QueryPerformanceCounter(&t1);

	Sleep(500);

	QueryPerformanceCounter(&t2);
	printf("windll sleep %.3f ms.\n",
		(double)(t2.QuadPart - t1.QuadPart)*1000.0/frequency.QuadPart);
}