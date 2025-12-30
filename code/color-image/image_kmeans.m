function [X, GMM] = image_kmeans(Y, k, g)
% IMAGE_KMEANS   Initialize segmentation using K-means
%
%   [X, GMM] = image_kmeans(Y, k, g)
%
%   Inputs:
%       Y           - Color image (m x n x 3)
%       k           - Number of label classes
%       g           - Number of GMM components per class
%
%   Outputs:
%       X           - Initial 2D labels
%       GMM         - Initial GMM parameters
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    [m, n, ~] = size(Y);
    y = reshape(Y, [m*n, 3]);
    x = kmeans(y, k);
    X = reshape(x, [m, n]);

    GMM = get_GMM(X, Y, g);
end