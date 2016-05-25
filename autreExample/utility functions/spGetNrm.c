/* -------------------------------------------------------------------------- */
/* getNrm_mex mexFunction */
/* -------------------------------------------------------------------------- */

#include "mex.h"

/* compute the vector to normalize 2D circulant operator */
void mexFunction
(
    int nargout,
    mxArray *pargout [ ],
    int nargin,
    const mxArray *pargin  [ ]
)
{
    double *d, *rM, *iM, *v, *p, nnp, mm, nn;
    ptrdiff_t  I, i, j, k, tau, s, t, alpha, beta, np, m, n, L, ir;

    if (nargin != 6 || nargout > 1)
        mexErrMsgTxt ("Usage: ell = getNrm (p, rM, iM, m, n, np)") ;

    /* ---------------------------------------------------------------- */
    /* inputs */
    /* ---------------------------------------------------------------- */
    
    p = mxGetPr( pargin [0]); 
    rM  = mxGetPr( pargin [1] );
    iM  = mxGetPr( pargin [2] );
    mm = mxGetScalar( pargin [3]); m = (ptrdiff_t) mm;
    nn = mxGetScalar( pargin [4]); n = (ptrdiff_t) nn;    
    nnp = mxGetScalar( pargin [5]); np = (ptrdiff_t) nnp;
    L = m*n;

    
    /* ---------------------------------------------------------------- */
    /* output */
    /* ---------------------------------------------------------------- */

    pargout [0] = mxCreateDoubleMatrix(1, L, mxREAL);
    v = mxGetPr( pargout [0] );
    for (i = 0; i<L; i++) v[i] = 0.0;
    
    
    /* C array indices start from 0 */
         
    for (k = 0; k<n; k++)
        for (tau = 0; tau<m; tau++) {
            j = tau+k*m;
            for (I = 0; I<np; I++){
                i = (ptrdiff_t) p[I];
                i -= 1;
                s = i/m; t = i%m;
                alpha = (m+tau-t)%m;
                beta = (n+k-s)%n;
                ir = alpha+beta*m;
                v[j] += (rM[ir]*rM[ir]+iM[ir]*iM[ir]);
                }
        }
    
    return;
}

