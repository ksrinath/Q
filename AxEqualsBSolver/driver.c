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
    double **Aprime,
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
    // print Aprime
    for ( int j = 0; j < n-i; j++ ) { 
      fprintf(stderr, " %2d ", (int)Aprime[i][j]);
    }

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
  double **Aprime = NULL;
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
    A[i] = (double *) malloc(n * sizeof(double));
    return_if_malloc_failed(A[i]);
  }
  /* Note that A is symmetric. We define top half */
  for ( int i = 0; i < n; i++ )  {
    for ( int j = i; j < n; j++ ) {
      A[i][j] = llabs(lrand48() % 16) + 1;
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
  /* The solver does not want a full matrix. So, we must convert A 
     to Aprime, which is allocated and initialized differently. */
  Aprime = (double **) malloc(n * sizeof(double*));
  return_if_malloc_failed(Aprime);
  for ( int i = 0; i < n; i++ ) { Aprime[i] = NULL; }
  for ( int i = 0; i < n; i++ ) { 
    Aprime[i] = (double *) malloc((n-i) * sizeof(double));
    return_if_malloc_failed(Aprime[i]);
  }
  for ( int i = 0; i < n; i++ ) { 
    for ( int j = 0; j < n-i; j++ ) { 
      Aprime[i][j] = A[i][j+i];
    }
  }
  //-----------------
  print_input(A, Aprime, x_expected, b, n);
  x = positive_solver(Aprime, b, n);

  fprintf(stderr, "x from solver is [ ");
  for (int i=0; i < n; i++) {
    fprintf(stderr, " %lf ", x[i]);
  }
  fprintf(stderr, "].\nChecking commences \n");
  for (int j=0; j < n; j++) {
    if ( x[j] != x_expected[j] ) { 
      fprintf(stderr, "FAILURE\n");
      go_BYE(-1); 
    }
  }
  fprintf(stderr, "SUCCESS\n");
BYE:
  if ( Aprime != NULL ) { 
    for ( int i = 0; i < n; i++ ) { 
      free_if_non_null(Aprime[i]);
    }
  }
  free_if_non_null(Aprime);
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
