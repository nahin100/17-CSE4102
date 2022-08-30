CC=gcc
OBJ=hellomake.o hellofunc.o
CFLAGS=-I.
DEPS=hellomake.h

all:
	gcc -o hello hello.c

hellomake: hellomake.c hellofunc.c
	gcc -o hellomake hellomake.c hellofunc.c -I.

%.o: %.c $(DEPS)
	gcc -c -o $@ $< $(CFLAGS)

hellomake2: hellomake.o hellofunc.o
	gcc -o hellomake hellomake.o hellofunc.o

hellomake3: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)