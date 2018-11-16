/**
 * Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>,
 * Signal Analysis and Machine Perception Laboratory,
 * Department of Electrical, Computer, and Systems Engineering,
 * Rensselaer Polytechnic Institute, Troy, NY 12180, USA
 */

/**
 * This function expands the matrix using mirror boundary condition. 
 * For example, 
 *
 * A = [
 *     1  2  3  11
 *     4  5  6  12
 *     7  8  9  13
 *     ]
 *
 * B = BoundMirrorExpand(A) will yield
 *
 *     5  4  5  6  12  6
 *     2  1  2  3  11  3
 *     5  4  5  6  12  6 
 *     8  7  8  9  13  9 
 *     5  4  5  6  12  6
 */

#include "mex.h"
#include <cstdlib>
#include <cstdio>
#include <cmath>
#include <iostream>

double *boundMirrorExpand(double *A, int m, int n)
{
    double *B=new double[(m+2)*(n+2)];
    B[0+0*(m+2)]=A[1+1*m];
    B[(m+1)+0*(m+2)]=A[(m-2)+1*m];
    B[0+(n+1)*(m+2)]=A[1+(n-2)*m];
    B[(m+1)+(n+1)*(m+2)]=A[(m-2)+(n-2)*m];
    for(int i=1;i<n+1;i++)
    {
        B[0+i*(m+2)]=A[1+(i-1)*m];
        B[m+1+i*(m+2)]=A[m-2+(i-1)*m];
    }
    for(int i=1;i<m+1;i++)
    {
        B[i+0*(m+2)]=A[(i-1)+1*m];
        B[i+(n+1)*(m+2)]=A[i-1+(n-2)*m];
    }
    for(int i=1;i<m+1;i++)
    {
        for(int j=1;j<n+1;j++)
        {
            B[i+j*(m+2)]=A[i-1+(j-1)*m];
        }
    }
    return B;
}

void copyMatrix(double *A, double *B, int m, int n)
{
    for(int i=0;i<m*n;i++)
    {
        B[i]=A[i];
    }
}

void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    if(nrhs!=1)
    {
        mexErrMsgIdAndTxt( "MATLAB:BoundMirrorExpand:invalidNumInputs",
                "One input required.");
    }
    if(nlhs!=1)
    {
        mexErrMsgIdAndTxt( "MATLAB:BoundMirrorExpand:invalidNumOutputs",
                "One output required.");
    }
    
    double *A=mxGetPr(prhs[0]);
    int m=mxGetM(prhs[0]);
    int n=mxGetN(prhs[0]);
    
    if(m<3 || n<3)
    {
        mexErrMsgIdAndTxt( "MATLAB:BoundMirrorExpand:matrixTooSmall",
                "Input matrix is too small.");
    }
    
    plhs[0] = mxCreateDoubleMatrix(m+2, n+2, mxREAL);
    
    double *B=mxGetPr(plhs[0]);
    
    double *C=boundMirrorExpand(A,m,n);
    
    copyMatrix(C, B, m+2, n+2);
    
    delete[] C;

}