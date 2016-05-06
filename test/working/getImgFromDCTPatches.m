function [ img ] = getImgFromDCTPatches( patches, Rsize, overflow )
%GETIMGFROMPATCHES Return the image from the matrix containing patches
%   patches array containing patches, each column contains a single patche
%   pSize is the size of patches (they are squares)
%   overflow is the number of pixels of 'overflow'

if nargin == 2
    % The user did not want to have an overflowSize
    overflow = 0;
end

[vSize, nbrPatches] = size(patches);
pSize = sqrt(vSize);
RHeight = Rsize(1,1);
RWidth = Rsize(1,2);
img = zeros(RHeight,RWidth);

nbrCtemp = RWidth / (pSize-overflow);
nbrC = uint32(nbrCtemp);
% Pour être sûr d'arrondir au supérieur
if mod(nbrC,1) ~= 0 && mod(nbrC,1) < 0.5
    nbrC = nbrC + 1;
end

nbrRtemp = RHeight / pSize;
nbrR = uint32(nbrRtemp);
% Pour être sûr d'arrondir au supérieur
if mod(nbrR,1) ~= 0 && mod(nbrR,1) < 0.5
    nbrR = nbrR + 1;
end

count = 1;
for i = 1:nbrR
    for j = 1:nbrC
        x=1+(j-1)*(pSize-overflow);
        y=1+(i-1)*pSize;
        % Reshape so it is only in one column
        % Reshape store one colum after another
        index = (i-1)*nbrC+j;
        img(y:y+pSize-1,x:x+pSize-1) = idct2(reshape(patches(:,index), [pSize pSize]));
        count = count + 1;
    end
end

end

