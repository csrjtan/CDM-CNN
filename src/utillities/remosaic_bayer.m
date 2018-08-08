%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remosaic operation : use the CFA pixel value directly cover the cnn estimation
%   Input 
%    - rgb : cnn estimation rgb
%    - mosaic :  mosaic image
%    - pattern : mosaic pattern
%            pattern = 'grbg'
%            G R ..
%            B G ..
%            : :
%            pattern = 'rggb'
%            R G ..
%            G B ..
%    Output  double
%      - remosaick : remosaicked post-process image
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ remosaick  ] = remosaic_bayer( estimated , mosaic, pattern )

num = zeros(size(pattern));
p = find((pattern == 'r') + (pattern == 'R'));
num(p) = 1;
p = find((pattern == 'g') + (pattern == 'G'));
num(p) = 2;
p = find((pattern == 'b') + (pattern == 'B'));
num(p) = 3;

remosaick = estimated;
rows1 = 1:2:size(estimated,1);
rows2 = 2:2:size(estimated,1);
cols1 = 1:2:size(estimated,2);
cols2 = 2:2:size(estimated,2);

remosaick(rows1,cols1,num(1)) = mosaic(rows1,cols1,num(1));
remosaick(rows1,cols2,num(2)) = mosaic(rows1,cols2,num(2));
remosaick(rows2,cols1,num(3)) = mosaic(rows2,cols1,num(3));
remosaick(rows2,cols2,num(4)) = mosaic(rows2,cols2,num(4));

end
