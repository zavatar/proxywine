#include<stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
extern int expmain( int , char ** );
#ifdef __cplusplus
extern "C" }
#endif

int main( int argc, char *argv[] )
{
	printf("linuxmain: Call exported function of proxywine.so\n");
	expmain(argc, argv);
	
	FILE* fp = fopen("__funp.txt", "r");
    if (fp != NULL) {
        void (*func)(void);
        fscanf(fp, "%p", &func);
        printf("linuxmain: Call windll\n");
        func();
    }
    fclose(fp);
    
	return 0;
}
