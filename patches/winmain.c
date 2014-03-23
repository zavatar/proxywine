#include <stdio.h>
#include <setjmp.h>
#include <windows.h>

void (__stdcall *pFunc)(void);

void (*__longjmp)(jmp_buf, int);

int main(int argc, char* argv[])
{
    HMODULE h;
    FILE* fp;
    jmp_buf env;
    int i;
    char* buf;

    h = LoadLibrary("windll.dll");
    if (h != NULL) {
        pFunc = (void*)GetProcAddress(h, "windll");
        if (pFunc != NULL) {
            printf("winmain: Call windll\n");
            pFunc();
        }
    }

    if (argc >= 3) {
        memcpy(env, argv[argc-2], sizeof(jmp_buf));
        sscanf(argv[argc-1], "%p", &__longjmp);

        fp = fopen("__funp.txt", "w");
        if (fp != NULL)
            fprintf(fp, "%p\n", pFunc);
        fclose(fp);

        __longjmp(env, 2);
        printf("Never Executed!\n");
    }
}
