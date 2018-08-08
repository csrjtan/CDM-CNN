%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  bilinear interpolation
%    Input
%     - bayer :  bayer image or full color image
%    Output
%     - res : bilinear interpolation result
%
%                             [1 2 1]            [0 1 0]
%  R,B template:H_r = H_b =1/4[2 4 2]   H_g = 1/4[1 4 1]
%                             [1 2 1]            [0 1 0]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = bilinear(A)

%%% Load img, Full color or CFA both ok

[N,M,ch]=size(A);

%%%   If A is a full color image, 
%%%   Downsampled according to Bayer pattern
if ch==3
    B=zeros(N,M,'uint8');
    B(1:2:N,1:2:M)=A(1:2:N,1:2:M,2);  
    B(2:2:N,2:2:M)=A(2:2:N,2:2:M,2);  
    B(1:2:N,2:2:M)=A(1:2:N,2:2:M,1);  
    B(2:2:N,1:2:M)=A(2:2:N,1:2:M,3);
    A=B;
    clear B;
end

A = im2single(A);
% AÊÇobservated

%%% Seperate R,G,B Layer
R = zeros(N,M);
G = zeros(N,M);
B = zeros(N,M);

G(1:2:N,1:2:M)=A(1:2:N,1:2:M);  
G(2:2:N,2:2:M)=A(2:2:N,2:2:M);  
R(1:2:N,2:2:M)=A(1:2:N,2:2:M);  
B(2:2:N,1:2:M)=A(2:2:N,1:2:M);


%%% Recover of R,G,B %%%
resR = zeros(N,M);
resG = zeros(N,M);
resB = zeros(N,M);

%%% Simply using template
%                             [1 2 1]            [0 1 0]
%  R,B template:H_r = H_b =1/4[2 4 2]   H_g = 1/4[1 4 1]
%                             [1 2 1]            [0 1 0]
for i=2:N-1
    for j=2:M-1
        resG(i,j) = G(i,j)+G(i,j-1)/4+G(i,j+1)/4+G(i-1,j)/4+G(i+1,j)/4;
        resR(i,j) = R(i,j)+R(i,j-1)/2+R(i,j+1)/2+R(i-1,j)/2+R(i+1,j)/2+...
            R(i-1,j-1)/4+R(i+1,j-1)/4+R(i-1,j+1)/4+R(i+1,j+1)/4;
        resB(i,j) = B(i,j)+B(i,j-1)/2+B(i,j+1)/2+B(i-1,j)/2+B(i+1,j)/2+...
            B(i-1,j-1)/4+B(i+1,j-1)/4+B(i-1,j+1)/4+B(i+1,j+1)/4;
    end
end

% Show the Demosaicing result
res = zeros(N,M,3);
res(:,:,1) = resR(:,:);
res(:,:,2) = resG(:,:);
res(:,:,3) = resB(:,:);




