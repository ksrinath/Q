/* 
 * Andrew Winkler
It has the virtue of dramatic simplicity - there's no need to explicitly construct the cholesky decomposition, no need to do the explicit backsubstitutions.

Yet it's essentially equivalent to that more labored approach, so its performance/stability/memory, etc. should be at least as good.

*/
#include <stdlib.h>
#include "positive_solver.h"
void _positive_solver(
    double ** A, 
    double * b, 
    double * x, 
    int n
    ) 
{
  if (n < 1) exit(-1);
  if (n == 1) {
    x[0] = b[0] / A[0][0];
    return;
  }

  double * bvec = b + 1;
  double * Avec = A[0] + 1;
  double ** Asub = A + 1;
  double * xvec = x + 1;

  int m = n -1;

  for(int j=0; j < m; j++){
    bvec[j] -= Avec[j] * b[0] / A[0][0];
    for(int i=0; i < m - j; i++)
      Asub[i][j] -= Avec[i] * Avec[j] / A[0][0];
  }

  _positive_solver(Asub, bvec, xvec, m);

  double p = 0; for(int k=0; k<m; k++) p += Avec[k] * xvec[k];

  x[0] = (b[0] - p) / A[0][0];

  return;
}

#include <malloc.h>
double * positive_solver(
    double ** A, 
    double * b, 
    int n
    ) 
{
  double * x = (double *) malloc(n * sizeof(double));
  _positive_solver(A, b, x, n);
  return x;
}
