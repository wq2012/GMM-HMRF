function [i, j] = ind2ij(ind, m)
% IND2IJ   Convert linear index to subscripts (2D)
%
%   [i, j] = ind2ij(ind, m)
%
%   Inputs:
%       ind         - Linear index
%       m           - Number of rows
%
%   Outputs:
%       i, j        - Row and column subscripts (1-based)
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    i = mod(ind - 1, m) + 1;
    j = floor((ind - 1) / m) + 1;
end