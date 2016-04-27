% Algorithme de test
clear variables
close all
clc

img = imread('img.pgm');
if size(img,3)==3 % Convertion en nuance de gris si RGB avant
   img = rgb2gray(img);
end

regions = getRegions(img);

patchesR1 = getPatches(regions(:,:,1), 8, 2);

imshow(patchesR1)