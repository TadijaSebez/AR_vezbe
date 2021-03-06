#include <stdio.h>
#include <string.h>

unsigned int RUNPP_REG_ERR = 0;

unsigned int oct_str_float_to_inter(char* str, unsigned int baza, unsigned int* greska);

int main() {
    unsigned int r;
    char s[30]={0};
    unsigned int g;
    unsigned int baza;
    printf("Unesite bazu (od 2 do 36):");
    scanf("%u",&baza);
    printf("Unesite broj u odabranoj osnovi (sa 0.):");
    scanf("\n%30[^\n]s",s);
    r = oct_str_float_to_inter(s,baza,&g);
    printf("Greska: %u\n",g);
    if (g == 0)
        printf("Rezultat: %u\n",r);
    printf("\n");

    #ifdef LEVEL42
    printf("\nRUNPP_REG_ERR:%d\n",RUNPP_REG_ERR);
    #endif
    return ((g<0)||(g>127))?127:g;
}


