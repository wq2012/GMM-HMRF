function [i, j, q] = ind2ijq(ind, m, n)
% IND2IJQ   Convert linear index to subscripts (3D)
%
%   [i, j, q] = ind2ijq(ind, m, n)
%
%   Inputs:
%       ind         - Linear index
%       m           - Number of rows
%       n           - Number of columns
%
%   Outputs:
%       i, j, q     - Row, column, and slice subscripts (1-based)
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    q = floor((ind - 1) / (m * n)) + 1;
    ind = ind - (q - 1) * m * n;
    i = mod(ind - 1, m) + 1;
    j = floor((ind - 1) / m) + 1;
end