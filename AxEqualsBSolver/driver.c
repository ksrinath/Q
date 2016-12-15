#include <stdio.h>
#include <stdlib.h>

#include "positive_solver.h"
int main(){
   int n = 3;

   double ** A = (double **) malloc(n * sizeof(double*));

   A[0] = (double *) malloc(3 * sizeof(double));
   A[0][0] = 3.0;
   A[0][1] = -1.0;
   A[0][2] = -1.0;
   A[1] = (double *) malloc(2 * sizeof(double));
   A[1][0] = 2.0;
   A[1][1] = -1.0;
   A[2] = (double *) malloc(1 * sizeof(double));
   A[2][0] = 2.0;

   double * b = (double *) malloc(n * sizeof(double));

   b[0] = -1.0;
   b[1] = -1.0;
   b[2] = 2.0;

   double * x = positive_solver(A, b, n);

   for (int j=0; j < n; j++) {
       printf("%f\n", x[j]);
   }
}
/* 
 * Andrew Winkler
It has the virtue of dramatic simplicity - there's no need to explicitly construct the cholesky decomposition, no need to do the explicit backsubstitutions.

Yet it's essentially equivalent to that more labored approach, so its performance/stability/memory, etc. should be at least as good.

*/
