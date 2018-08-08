%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Bilinear Interpolation
%    Input
%     - X : X image
%     - Y : Y image
%     - peak : signal peak value
%     - b : image border cut
%    Output
%     - cpsnr : composition peak signal noise ratio  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cpsnr = imcpsnr(X, Y, peak, b)

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
mse = sum( dif(:) ) / numel(dif) + 1e-32;
cpsnr = 10 * log10( peak*peak / mse );

end
