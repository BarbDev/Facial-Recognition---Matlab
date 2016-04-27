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
overflowSize = 2;
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
sizePatcheVector/pSize
(sizePatcheVector/pSize)*overflowSize-overflowSize
nbrPatches-(sizePatcheVector/pSize)*overflowSize
RegionSize = sqrt(nbrPatches)*pSize; % ATTENTION PRENDRE EN COMPTE OVERFLOW
% Pre-allocation for performance
imgf = uint8(zeros(RegionSize,RegionSize));

%patches = uint8(zeros(pSize*pSize,nbrRow*nbrCol));
for i = 0:RegionSize/pSize-1
    for j = 0:RegionSize/pSize-1
        index = 1+j+i*(RegionSize/pSize); %+1 car on part de 0
        vectorP = patches(:,index);
        patch = reshape(vectorP, [pSize pSize]);
        % a chaque fois que l'on atteint le nbe de patch par ligne, on saut à
        % la suivante
        x=1+j*pSize;
        y=1+i*pSize;
        imgf(y:y+pSize-1,x:x+pSize-1) = patch;
    end
end
