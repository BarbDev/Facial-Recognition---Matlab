#include "mex.h"
#include "stdio.h"
void mexFunction(
        int nargout,
        mxArray *pargout [ ],
        int nargin,
        const mxArray *pargin  [ ]
        ) {
    double *X, *Y;
    int n1, n2, N1, N2, i, j, row, n, w1, w2, rowSt, colSt, rowN, colN;
    int res1, res2, sgn1 = 0, sgn2 = 0, p, q, col = -1;
    if (nargin != 7 || nargout != 1)
        mexErrMsgTxt("Usage: Y = PtRtFunc (X,n1,n2,N1,N2,rowSt,colSt)");
    
    X = mxGetPr( pargin [0]);
    p = mxGetN( pargin [0]);
    n1 = (int) mxGetScalar( pargin [1]);
    n2 = (int) mxGetScalar( pargin [2]);
    N1 = (int) mxGetScalar( pargin [3]);
    N2 = (int) mxGetScalar( pargin [4]);
    rowSt = (int) mxGetScalar( pargin [5]);
    colSt = (int) mxGetScalar( pargin [6]);
    
    if (rowSt >= n1 || colSt >= n2 || (rowSt > 1 && colSt > 1))
        mexErrMsgTxt("Start point is not correct");
    
    rowN = (N1-rowSt+1)/n1; colN = (N2-colSt+1)/n2;
    res1 = N1-rowSt+1-rowN*n1; res2 = N2-colSt+1-colN*n2;
    if (res1 > 0)        sgn1 = 1;
    if (res2 > 0)        sgn2 = 1;
    q = rowN*colN+sgn1*colN+sgn2*rowN+sgn1*sgn2;
    if (rowSt > 1)
        q += colN + sgn2;
    if (colSt > 1)
        q += rowN + sgn1;
    if (p != q)
        mexErrMsgTxt("The input matrix X has not enough columns");
    
    n = n1*n2;
    pargout [0] = mxCreateDoubleMatrix(N1, N2, mxREAL);
    Y = mxGetPr( pargout [0]);
    
    if (rowSt > 1){
        for (col=0; col<colN; col++)
            for (w2=0; w2<n2; w2++)
                for (w1=0; w1<rowSt-1; w1++){
                row = w2*n1+w1;
                Y[(col*n2+w2)*N1+w1] = X[col*n+row];
                }
        col--;
        if (sgn2 > 0){
            col++;
            for (w2=n2-res2; w2<n2; w2++)
                for (w1=0; w1<rowSt-1; w1++){
                row = w2*n1+w1;
                Y[(col*n2+w2-n2+res2)*N1+w1] = X[col*n+row];
                }
        }
    }
    
    if (colSt > 1){
        for (col=0; col<rowN; col++)
            for (w2=0; w2<colSt-1; w2++)
                for (w1=0; w1<n1; w1++){
                row = w2*n1+w1;
                Y[w2*N1+col*n1+w1] = X[col*n+row];
                }
        col--;
        if (sgn1 > 0){
            col++;
            for (w2=0; w2<colSt-1; w2++)
                for (w1=n1-res1; w1<n1; w1++){
                row = w2*n1+w1;
                Y[w2*N1+col*n1+w1-n1+res1] = X[col*n+row];
                }
        }
    }
    
    for (j=0; j<colN; j++){
        for(i=0; i<rowN; i++){
            col++;
            for(w2=0;w2<n2;w2++)
                for(w1=0;w1<n1;w1++){
                row = w2*n1+w1;
                Y[(j*n2+w2+colSt-1)*N1+i*n1+w1+rowSt-1] = X[col*n+row];
                }
        }
        if (sgn1 > 0){
            col++;
            for (w2=0; w2<n2; w2++)
                for (w1=n1-res1; w1<n1; w1++){
                row = w2*n1+w1;
                Y[(j*n2+w2+colSt-1)*N1+rowN*n1+w1-n1+res1+rowSt-1] = X[col*n+row];
                }
        }
    }
    if (sgn2 > 0){
        for(i=0; i<rowN; i++){
            col++;
            for(w2=n2-res2; w2<n2; w2++)
                for(w1=0; w1<n1; w1++){
                row = w2*n1+w1;
                Y[(colN*n2+w2-n2+res2+colSt-1)*N1+i*n1+w1+rowSt-1] = X[col*n+row];
                }
        }
        if (sgn1 > 0){
            col++;
            for(w2=n2-res2; w2<n2; w2++)
                for (w1 = n1-res1; w1<n1; w1++){
                row = w2*n1+w1;
                Y[(colN*n2+w2-n2+res2+colSt-1)*N1+i*n1+w1-n1+res1+rowSt-1] = X[col*n+row];
                }
        }
    }
}