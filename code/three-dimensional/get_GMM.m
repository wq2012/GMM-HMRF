function GMM = get_GMM(X, Y, g)
% GET_GMM   Fit Gaussian Mixture Models to labeled 3D regions
%
%   GMM = get_GMM(X, Y, g)
%
%   Inputs:
%       X           - Labeled 3D volume
%       Y           - 3D volume data
%       g           - Number of GMM components per region
%
%   Outputs:
%       GMM         - Cell array of GMM parameters for each region
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    k = max(X(:));
    GMM = cell(k, 1);

    for i = 1:k
        index = (X == i);
        GMM{i} = gmdistribution.fit(Y(index), g, 'Regularize', 1);
    end
end