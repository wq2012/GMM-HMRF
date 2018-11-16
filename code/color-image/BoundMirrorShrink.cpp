/**
 * Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>,
 * Signal Analysis and Machine Perception Laboratory,
 * Department of Electrical, Computer, and Systems Engineering,
 * Rensselaer Polytechnic Institute, Troy, NY 12180, USA
 */

/**
 * This function shrinks the matrix to remove the padded mirror boundaries, 
 * For example,  
 *
 * A = [
 *     5  4  5  6  12  6
 *     2  1  2  3  11  3
 *     5  4  5  6  12  6 
 *     8  7  8  9  13  9 
 *     5  4  5  6  12  6
 *     ]
 * 
 * B = BoundMirrorShrink(A) will yield
 *
 *     1  2  3  11
 *     4  5  6  12
 *     7  8  9  13
 */

#include "mex.h"
#include <cstdlib>
#include <cstdio>
#include <cmath>
#include <iostream>

double *boundMirrorShrink(double *A, int m, int n)
{
    double *B=new double[(m-2)*(n-2)];
    for(int i=0;i<m-2;i++)
    {
        for(int j=0;j<n-2;j++)
        {
            B[i+j*(m-2)]=A[i+1+(j+1)*m];
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
        mexErrMsgIdAndTxt( "MATLAB:BoundMirrorShrink:invalidNumInputs",
                "One input required.");
    }
    if(nlhs!=1)
    {
        mexErrMsgIdAndTxt( "MATLAB:BoundMirrorShrink:invalidNumOutputs",
                "One output required.");
    }
    
    double *A=mxGetPr(prhs[0]);
    int m=mxGetM(prhs[0]);
    int n=mxGetN(prhs[0]);
    
    if(m<4 || n<4)
    {
        mexErrMsgIdAndTxt( "MATLAB:BoundMirrorShrink:matrixTooSmall",
                "Input matrix is too small.");
    }
    
    plhs[0] = mxCreateDoubleMatrix(m-2, n-2, mxREAL);
    
    double *B=mxGetPr(plhs[0]);
    
    double *C=boundMirrorShrink(A,m,n);
    
    copyMatrix(C, B, m-2, n-2);
    
    delete[] C;

}