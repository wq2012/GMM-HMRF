function retval = is_octave()
% IS_OCTAVE   Returns true if the environment is Octave, false otherwise.
%
%   retval = is_octave()
%
%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

    retval = exist('OCTAVE_VERSION', 'builtin') ~= 0;
end
