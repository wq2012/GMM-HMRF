% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

function GI=gaussianBlur(I,s)
%%  perform Gaussian blur
%   I: input image
%   s: standard deviation (sigma)
%   GI: blurred image

h=fspecial('gaussian',ceil(s)*3+1,s);

GI=imfilter(I,h,'replicate');
