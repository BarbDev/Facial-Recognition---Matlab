function [ patches ] = getPatches( img, pSize, overflow )
%GETPATCHES Return a matrix where each column is a patche of img
%   img is the image to be cut in patches
%   pSize is the size of patches (they are squares)
%   overflowSize is the number of pixels of 'overflow'
%
%   Each patches is stored in one column the size of pSize, and each column
%   is ordered as follow:
%   From the upper left (column 1) of the image to the right and lower
%   (column N)

if nargin == 2
    % The user did not want to have an overflowSize
    overflow = 0;
end

if overflow >= pSize
    error('The overflowSize cannot be equal or superior to pSize')
end

% Image carré avec patch carré
% On calcul le nombre de fois que l'on doit boucler
% On met l'overflow sur l'axe des abscisses
[RHeight, RWidth] = size(img);

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

patches = zeros(pSize*pSize,nbrR*nbrC, 'uint8');
count = 1;
for i = 1:nbrR
    for j = 1:nbrC
        x=1+(j-1)*(pSize-overflow);
        y=1+(i-1)*pSize;
        % Reshape so it is only in one column
        % Reshape store one colum after another
        patch = imcrop(img, [x y pSize-1 pSize-1]);
        [pHeight, pWidth] = size(patch);
        if pHeight ~= pSize
            missHeight = pSize-pHeight;
            missing = flipud(imcrop(img, [x RHeight-missHeight pSize-1 missHeight-1])); %flipud -> mirroring up->down
            patch = [patch missing];
        end
        if pWidth ~= pSize
            missWidth = pSize-pWidth;
            missing = fliplr(imcrop(img, [RWidth-missWidth y missWidth-1 pSize-1])); %fliplr -> mirroring left-right
            patch = [patch missing];
        end
        patches(:,count) = reshape(patch, [pSize*pSize 1]);
        count = count + 1;
    end
end

end

