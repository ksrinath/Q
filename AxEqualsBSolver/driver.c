/* To build: 
 * gcc -std=gnu99 driver.c positive_solver.c -Wall -O4 -pedantic -o driver 
 * To execute:
 * ./driver <n> # for some positive integer n
 * */
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "macros.h"
#include "positive_solver.h"
/* some utilities */
static void
print_input(
    double **A, 
    double *x, 
    double *b, 
    int n
    )
{
  for ( int i = 0; i < n; i++ ) { 
    fprintf(stderr, "[ ");
    for ( int j = 0; j < n; j++ ) { 
      if ( j == 0 ) { 
        fprintf(stderr, " %2d ", (int)(int)A[i][j]);
      }
      else {
        fprintf(stderr, ", %2d ", (int)A[i][j]);
      }
    }
    fprintf(stderr, "] ");
    // print x
    fprintf(stderr, " [ ");
    fprintf(stderr, " %2d ", (int)x[i]);
    fprintf(stderr, "] ");
    // print b
    fprintf(stderr, "  = [ ");
    fprintf(stderr, " %3d ", (int)b[i]);
    fprintf(stderr, "] ");

    fprintf(stderr, "\n");
  }
}
/* assembly code to read the TSC */
static inline uint64_t 
RDTSC(void)
{
  unsigned int hi, lo;
  __asm__ volatile("rdtsc" : "=a" (lo), "=d" (hi));
  return ((uint64_t)hi << 32) | lo;
}

int 
main(
    int argc,
    char **argv
    )
{
  int status = 0;
  double **A = NULL;
  double *x_expected = NULL;
  double *x = NULL; // allocated by positive_solver
  double *b = NULL;
  int n = 0;
  srand48(RDTSC());
  fprintf(stderr, "Usage is ./driver <n> \n");
  switch ( argc ) { 
    case 2 : n = atoi(argv[1]); break;
    default : go_BYE(-1); break;
  }

  A = (double **) malloc(n * sizeof(double*));
  return_if_malloc_failed(A);
  for ( int i = 0; i < n; i++ ) { A[i] = NULL; }
  for ( int i = 0; i < n; i++ ) { 
    A[i] = (double *) malloc(n * sizeof(double*));
    return_if_malloc_failed(A[i]);
  }
  /* Note that A is symmetric. We define top half */
  for ( int i = 0; i < n; i++ )  {
    for ( int j = i; j < n; j++ ) {
      A[i][j] = (lrand48() % 16) - 16/2;
    }
  }
  /* Now we copy top right half to bottom left half */
  for ( int i = 0; i < n; i++ )  {
    for ( int j = 0; j < i; j++ ) {
      A[i][j] = A[j][i];
    }
  }
  b = (double *) malloc(n * sizeof(double));
  return_if_malloc_failed(b);
  x_expected = (double *) malloc(n * sizeof(double));
  return_if_malloc_failed(x_expected);
  // Initialize x
  for ( int i = 0; i < n; i++ )  {
    x_expected[i] = (lrand48() % 16) - 16/2;
  }
  // Compute b
  for ( int i = 0; i < n; i++ ) { 
    double sum = 0;
    for ( int j = 0; j < n; j++ ) { 
      sum += A[i][j] * x_expected[j];
    }
    b[i] = sum;
  }
  print_input(A, x_expected, b, n);
  x = positive_solver(A, b, n);

  fprintf(stderr, "x from solver is [ ");
  for (int i=0; i < n; i++) {
    fprintf(stderr, " %lf ", x[i]);
  }
  fprintf(stderr, "]. Checking commences \n");
  for (int j=0; j < n; j++) {
    if ( x[j] != x_expected[j] ) { 
      go_BYE(-1); 
    }
  }
BYE:
  if ( A != NULL ) { 
    for ( int i = 0; i < n; i++ ) { 
      free_if_non_null(A[i]);
    }
  }
  free_if_non_null(A);
  free_if_non_null(x);
  free_if_non_null(x_expected);
  free_if_non_null(b);
  return status;
}
