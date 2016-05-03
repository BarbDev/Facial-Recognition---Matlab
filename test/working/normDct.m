function [ normVector ] = normDct( vPatch, pSize )
%NORMDCT Apply zero mean and variance + dct2
%   Reconstruct the patch from a vector and apply normalization to have
%   zero mean and unit variance.
%   Return the patch as a vector
%   VPATCH the patch to be treated
%   PSIZE the size of the patch (always a square)

patch = reshape(vPatch, [pSize pSize]);

X = double(patch);
% Zero mean
X=X-mean(X(:));
% Zero variance
X=X/std(X(:));
% Apply dct2
X = dct2(double(X));

normVector = reshape(X, [pSize*pSize 1]);

end

