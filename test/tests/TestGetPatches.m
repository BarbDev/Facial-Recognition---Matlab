% Algorithme de test
clear variables
close all
clc

img = imread('img.pgm');
if size(img,3)==3 % Convertion en nuance de gris si RGB avant
   img = rgb2gray(img);
end

img = getRegions(img);
img = img(:,:,1);

% img, pSize, overflowSize
pSize = 5;
% ne peut pas être plus de la même taille ou plus grand que pSize
overflowSize = 3;

count = 1;
% On cherche le nombre d'itération à faire (taille img et pSize)
[iHeight, iWidth] = size(img);
nbrRow = uint8(iWidth/(pSize-overflowSize)) % WARNING Must be interger
% when overflowSize is not pair
nbrCol = iHeight/pSize;
% nbrRow and nbrCol represent the number of of case representing a patche

patches = uint8(zeros(pSize*pSize,nbrRow*nbrCol));
for i = 0:nbrCol-1 % -1 car on part de 0 et on compte 6
    for j = 0:nbrRow-1
        x=1+j*(pSize-overflowSize-1) % -1 quand overflow != 0?
        y=1+i*pSize
        % Reshape so it is only in one column
        % Reshape store one colum after another
        size(imcrop(img, [x y pSize-1 pSize-1]))
        patches(:,count) = reshape(imcrop(img, [x y pSize-1 pSize-1]), ...
            [pSize*pSize 1]);
        count = count + 1;
    end
end

imshow(img)
imshow(patches)
