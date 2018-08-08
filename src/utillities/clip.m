%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  clipping operation
%    Input
%     - X : input value
%     - lo: lowest value
%     - hi: highest value
%    Output
%     - Y : output value among [lo,hi]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Y] = clip(X, lo, hi)
Y = X;
Y(X<lo) = lo;
Y(X>hi) = hi;
end
