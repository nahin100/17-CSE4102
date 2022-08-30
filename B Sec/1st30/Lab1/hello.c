#include<stdio.h>

int main()
{
    int a, b, c;
    b = 10;
    c = 20;
    a = b + c;
    printf("a = %d\n", a);
    //Preprocess: gcc -E hello.c > hello.i
    //Compiling: gcc -S -masm=intel hello.i
    //Assembling: as -o hello.o hello.s
    //OBJECT file inside: objdump -d hello.o
    //gcc -o hello hello.c


}