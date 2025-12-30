function GI = gaussianBlur(I, s)
% GAUSSIANBLUR   Perform Gaussian blur on an image
%
%   GI = gaussianBlur(I, s)
%
%   Inputs:
%       I           - Input image
%       s           - Standard deviation (sigma)
%
%   Outputs:
%       GI          - Blurred image
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    h = fspecial('gaussian', ceil(s) * 3 + 1, s);
    GI = imfilter(I, h, 'replicate');
end
