#include<stdio.h>

int main()
{
    int a, b, c;
    b = 10;
    c = 20;
    a = b + c;
    printf("a = %d\n", a);
    //gcc -o HelloWorld HelloWorld.c
    //gcc -E HelloWorld.c > HelloWorld.i 
    //gcc -S -masm=intel HelloWorld.i
    //as -o HelloWorld.o HelloWorld.s
    //objdump -M intel -d HelloWorld.o > HelloWorld.dump
}