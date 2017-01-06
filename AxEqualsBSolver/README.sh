gcc -O4 positive_solver.c driver.c -std=gnu99 -o driver
valgrind ./driver 100
