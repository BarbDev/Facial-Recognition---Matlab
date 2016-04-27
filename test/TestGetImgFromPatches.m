%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithme de test
clear variables
close all
clc
img = imread('img.pgm');
if size(img,3)==3 % Convertion en nuance de gris si RGB avant
   img = rgb2gray(img);
end
regions = getRegions(img);
pSize = 8;
overflowSize = 0;
patches = getPatches(regions(:,:,1), pSize, overflowSize);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Début de la fonction à tester
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable dispo: les patches et le overflowSize

% On cherche le nombre d'itération à faire
[sizePatcheVector, nbrPatches] = size(patches);
% Chaque patche étant un carré, la racine carré de la longueur du vecteur
% du patch nous donne sa taille
pSize = sqrt(sizePatcheVector);
RegionSize = 48; % ATTENTION PRENDRE EN COMPTE OVERFLOW
% Pre-allocation for performance
imgf = uint8(zeros(RegionSize,RegionSize));

nbrColumn = uint8(RegionSize/(pSize-overflowSize))
count = 0;
j = 0;
for i = 1:nbrPatches
    if count == RegionSize/pSize
        count = 0;
        j = j +1;
    end
    vectorP = patches(:,i);
    patch = reshape(vectorP, [pSize pSize]);
    x=1+count*(pSize-overflowSize-1);
    y=1+j*pSize;
    imgf(y:y+pSize-1,x:x+pSize-1) = patch;
    count = count +1;
end
% for i = 0:RegionSize/pSize-1
%     for j = 0:nbrColumn-1
%         index = 1+j+i*(RegionSize/pSize); %+1 car on part de 0
%         vectorP = patches(:,index);
%         patch = reshape(vectorP, [pSize pSize]);
%         % a chaque fois que l'on atteint le nbe de patch par ligne, on saut à
%         % la suivante
%         x=1+j*(pSize-overflowSize-1);
%         y=1+i*pSize;
%         imgf(y:y+pSize-1,x:x+pSize-1) = patch;
%     end
% end
imshow(img)
figure
imshow(patches)
figure
imshow(imgf)