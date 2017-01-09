#!/bin/bash
# All auto-generated .c files are created here
# quick check as follows
gcc  -c -std=gnu99 -I../inc/ *.c -fPIC -Wall -O4 -pedantic -fopenmp
gcc -shared *.o -o _libfoo.so


