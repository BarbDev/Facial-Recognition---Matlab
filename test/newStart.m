%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithme de test
clear variables
close all
clc
%img = imread('img.pgm');
img = imread('cameraman.tif');
if size(img,3)==3 % Convertion en nuance de gris si RGB avant
   img = rgb2gray(img);
end
regions = getRegions(img);
R = regions(:,:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                VARIABLES
%
[RHeight, RWidth] = size(R);
%Rsize = size(R);
%Rsize = Rsize(1,1);
pSize = 8;
overflow = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Image carré avec patch carré
% On calcul le nombre de fois que l'on doit boucler
% On met l'overflow sur l'axe des abscisses
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
size(patches)
% imshow(R)
% hold on
% rectangle('Position', [1 1 pSize-1 pSize-1] );
count = 1;
for i = 1:nbrR
    for j = 1:nbrC
        x=1+(j-1)*(pSize-overflow);
        y=1+(i-1)*pSize;
        % Reshape so it is only in one column
        % Reshape store one colum after another
        patch = imcrop(R, [x y pSize-1 pSize-1]);
        [pHeight, pWidth] = size(patch);
        if pHeight ~= pSize
            missHeight = pSize-pHeight;
            missing = flipud(imcrop(R, [x RHeight-missHeight pSize-1 missHeight-1])); %flipud -> mirroring up->down
            patch = [patch missing];
        end
        if pWidth ~= pSize
            missWidth = pSize-pWidth;
            missing = fliplr(imcrop(R, [RWidth-missWidth y missWidth-1 pSize-1])); %fliplr -> mirroring left-right
            patch = [patch missing];
        end
        patches(:,count) = reshape(patch, [pSize*pSize 1]);
        count = count + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newIMG = zeros(RHeight,RWidth, 'uint8');
[vSize, nbrPatches] = size(patches);
count = 1;
for i = 1:nbrR
    for j = 1:nbrC
        x=1+(j-1)*(pSize-overflow);
        y=1+(i-1)*pSize;
        % Reshape so it is only in one column
        % Reshape store one colum after another
        index = (i-1)*nbrC+j;
        newIMG(y:y+pSize-1,x:x+pSize-1) = reshape(patches(:,index), [pSize pSize]);
        count = count + 1;
    end
end

imshow(newIMG)