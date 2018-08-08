%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Bilinear Interpolation
%    Input
%     - X : X image
%     - Y : Y image
%     - peak : signal peak value
%     - b : image border cut
%    Output
%     - psnr : peak signal noise ratio 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function psnr = impsnr(X, Y, peak, b)

if( nargin < 3 )
 peak = 255;
end

if( nargin < 4 )
 b = 0;
end

if( b > 0 )
 X = X(b:size(X,1)-b, b:size(X,2)-b,:);
 Y = Y(b:size(Y,1)-b, b:size(Y,2)-b,:);
end

dif = (X - Y);
dif = dif .* dif;
for i=1:size(dif, 3)
 d = dif(:,:,i);
 mse = sum( d(:) ) / numel(d)+1e-32;
 psnr(i) = 10 * log10( peak * peak / mse );
end

end
