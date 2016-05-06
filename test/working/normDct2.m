function [ newPatches ] = normDct2( patches, doMean, doVar )
%NORMDCT Apply zero mean and variance + dct2
%   Reconstruct the patch from a vector and apply normalization to have
%   zero mean and unit variance.
%   Return the patch as a vector
%   VPATCH the patch to be treated
%   PSIZE the size of the patch (always a square)
if nargin ~= 3
    error('Not enough argument')
end

[vSize, nbrFeature] = size(patches);
pSize = sqrt(vSize);
newPatches = patches; % Memory allocation

for i = 1:nbrFeature
    %% On normalise les patches pour avoir 'zero mean and unit variance'
    X = reshape(patches(:,i), [pSize pSize]);
    if doMean
        X = X-mean2(X); % Zero mean
    end
    if doVar
        X = X/std2(X); % Zero variance
    end
    X = dct2(X);
    newPatches(:,i) = reshape(X, [pSize*pSize 1]);
end

end

