#include <stdio.h>
#include <ctype.h>
#include <stdlib.h> 
#include <string.h>

int main(int argc, char *argv[]){
    FILE *inp;
    char r;
    short i;

    if ((inp = fopen("empname.bin","r")) == NULL){
    printf("could not open file for reading\n");
    exit(1);}

   
    int32_t num=0;
    
    fread(&num, sizeof(int32_t), 1, inp);

    printf("The integer is %d\n",num);   
    
    fread(&num, sizeof(int32_t), 1, inp);
    printf("The integer is %d\n",num);   
    
}