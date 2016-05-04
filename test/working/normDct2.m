function [ normVector ] = normDct2( vPatch, pSize, doNorm )
%NORMDCT Apply zero mean and variance + dct2
%   Reconstruct the patch from a vector and apply normalization to have
%   zero mean and unit variance.
%   Return the patch as a vector
%   VPATCH the patch to be treated
%   PSIZE the size of the patch (always a square)
if nargin ~= 3
    error('Not enough argument')
end

patch = reshape(vPatch, [pSize pSize]);

X = double(patch);
if doNorm
    % Zero mean
    X = X-mean(X(:));
    % Zero variance
    X = X/std(X(:));
end
% Apply dct2
X = dct2(double(X));

normVector = reshape(X, [pSize*pSize 1]);

end

