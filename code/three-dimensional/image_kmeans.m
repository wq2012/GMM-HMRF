function [X, GMM] = image_kmeans(Y, k, g)
% IMAGE_KMEANS   Initialize segmentation using K-means (3D)
%
%   [X, GMM] = image_kmeans(Y, k, g)
%
%   Inputs:
%       Y           - 3D volume (m x n x p)
%       k           - Number of label classes
%       g           - Number of GMM components per class
%
%   Outputs:
%       X           - Initial 3D labels
%       GMM         - Initial GMM parameters
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    [m, n, p] = size(Y);
    y = Y(:);
    x = kmeans(y, k);
    X = reshape(x, [m, n, p]);

    GMM = get_GMM(X, Y, g);
end