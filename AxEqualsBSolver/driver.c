/* To build: 
 * gcc -std=gnu99 driver.c positive_solver.c -Wall -O4 -pedantic -o driver 
 * To execute:
 * ./driver <n> # for some positive integer n
 * */
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <inttypes.h>
#include "macros.h"
#include "positive_solver.h"
/* some utilities */
static void  free_matrix(
      double **A,
      int n
      )
{
  if ( A != NULL ) { 
    for ( int i = 0; i < n; i++ ) { 
      free_if_non_null(A[i]);
    }
  }
  free_if_non_null(A);
}
static void multiply_matrix_vector(
    double **A, 
    double *x,
    int n,
    double *b
    )
{
  for ( int i = 0; i < n; i++ ) { 
    double sum = 0;
    for ( int j = 0; j < n; j++ ) { 
      sum += A[i][j] * x[j];
    }
    b[i] = sum;
  }
}
static int 
alloc_matrix(
    double ***ptr_X, 
    int n
    )
{
  int status = 0;
  double **X = NULL;
  *ptr_X = NULL;
  X = (double **) malloc(n * sizeof(double*));
  return_if_malloc_failed(X);
  for ( int i = 0; i < n; i++ ) { X[i] = NULL; }
  for ( int i = 0; i < n; i++ ) { 
    X[i] = (double *) malloc(n * sizeof(double));
    return_if_malloc_failed(X[i]);
  }
  *ptr_X = X;
BYE:
  return status;
}
static void 
multiply(
    double **A,
    double **B,
    double **C,
    int n
    )
{
  for ( int i = 0; i < n; i++ ) { 
    for ( int j = 0; j < n; j++ ) { 
      double sum = 0;
      for ( int k = 0; k < n; k++ ) { 
        sum += A[i][k] * B[k][j];
      }
      C[i][j] = sum;
    }
  }
}

static void 
transpose(
    double **A,
    double **B,
    int n
    )
{
  for ( int i = 0; i < n; i++ ) { 
    for ( int j = 0; j < n; j++ ) { 
      B[i][j] = A[j][i];
    }
  }
}

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
  double **AT = NULL; // A transpose
  double **AAT = NULL; // A times A transpose
  double **Aprime = NULL;
  double *x_expected = NULL;
  double *x = NULL; // allocated by positive_solver
  double *b = NULL;
  double *bprime = NULL;
  double *b_solver = NULL; // since solver messes up original b
  int n = 0;
  srand48(RDTSC());
  fprintf(stderr, "Usage is ./driver <n> \n");
  switch ( argc ) { 
    case 2 : n = atoi(argv[1]); break;
    default : go_BYE(-1); break;
  }
  status = alloc_matrix(&A, n); cBYE(status);
  status = alloc_matrix(&AT, n); cBYE(status);
  status = alloc_matrix(&AAT, n); cBYE(status);

  /* Note that A is symmetric. We define top half */
  for ( int i = 0; i < n; i++ )  {
    for ( int j = i; j < n; j++ ) {
      A[i][j] = llabs(lrand48() % 4) + 1;
    }
  }
  /* Now we copy top right half to bottom left half */
  for ( int i = 0; i < n; i++ )  {
    for ( int j = 0; j < i; j++ ) {
      A[i][j] = A[j][i];
    }
  }
  transpose(A, AT, n);
  multiply(A, AT, AAT, n);
  b_solver = (double *) malloc(n * sizeof(double));
  return_if_malloc_failed(b_solver);
  bprime = (double *) malloc(n * sizeof(double));
  return_if_malloc_failed(bprime);
  b = (double *) malloc(n * sizeof(double));
  return_if_malloc_failed(b);
  x_expected = (double *) malloc(n * sizeof(double));
  return_if_malloc_failed(x_expected);
  // Initialize x
  for ( int i = 0; i < n; i++ )  {
    x_expected[i] = (lrand48() % 16) - 16/2;
  }
  multiply_matrix_vector(AAT, x_expected, n, b);
  /* The solver does not want a full matrix. So, we must convert A 
     to Aprime, which is allocated and initialized differently. */
  Aprime = (double **) malloc(n * sizeof(double*));
  return_if_malloc_failed(Aprime);
  for ( int i = 0; i < n; i++ ) { Aprime[i] = NULL; }
  for ( int i = 0; i < n; i++ ) { 
    Aprime[i] = (double *) malloc((n-i) * sizeof(double));
    return_if_malloc_failed(Aprime[i]);
  }
  //---------------------------
  for ( int i = 0; i < n; i++ ) { 
    for ( int j = 0; j < n-i; j++ ) { 
      Aprime[i][j] = AAT[i][j+i];
    }
  }
  //-----------------
  for ( int i = 0; i < n; i++ ) { 
    b_solver[i] = b[i];
  }
  print_input(AAT, Aprime, x_expected, b_solver, n);
  x = positive_solver(Aprime, b_solver, n);

  fprintf(stderr, "x from solver is [ ");
  for (int i=0; i < n; i++) {
    fprintf(stderr, " %lf ", x[i]);
  }
  fprintf(stderr, "].\nChecking commences \n");
  // Compute bprime
  multiply_matrix_vector(AAT, x, n, bprime);
  bool error = false;
  fprintf(stderr, "x(good) x(computed) b(good), b(solver) \n");
  for (int i=0; i < n; i++) {
    fprintf(stderr, " %lf %lf %lf %lf ", 
        x_expected[i], x[i], b[i], bprime[i]);
    if ( abs(bprime[i] - b[i]) < 0.001 ) { 
      fprintf(stderr, " MATCH \n");
    }
    else {
      error = true; 
      fprintf(stderr, " ERROR \n");
    }
  }
  if ( error ) {
    fprintf(stderr, "FAILURE\n");
  }
  else {
    fprintf(stderr, "SUCCESS\n");
  }
BYE:
  free_matrix(A, n);
  free_matrix(AT, n);
  free_matrix(AAT, n);
  if ( Aprime != NULL ) { 
    for ( int i = 0; i < n; i++ ) { 
      free_if_non_null(Aprime[i]);
    }
  }
  free_if_non_null(Aprime);
  free_if_non_null(x);
  free_if_non_null(x_expected);
  free_if_non_null(b);
  free_if_non_null(bprime);
  free_if_non_null(b_solver);
  return status;
}
/*
My initial checking failed. 

Andrew: Ok, the problem is that if A isn’t positive, there are
multiple solutions. Rather than checking that x is what you expect,
instead check that Ax = b There’s no reason why the algorithm would
come up with the same solution when it’s not unique And since these
random matrices aren’t being compelled to be positive, there will be
multiple solutions

Ramesh Subramonian: BTW, is this correct: A positive matrix is a matrix
in which all the elements are greater than zero.

Andrew Winkler: No, a positive matrix is one for which xtAx > 0 unless
x is 0

Ramesh Subramonian: ahah! remind me not to trust Google when I have a
professional mathematician to rely on!

*/
