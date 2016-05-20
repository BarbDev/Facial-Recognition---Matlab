clc
clear variables
close all

img = double(imread('01.pgm'));
%img = double(imread('img.pgm'));
%GETREGIONS Return 4 regions of the image
%   The regions are stored in a matrix of ?:?:4 and returned

% Lecture de la taille de l'image
[height, width] = size(img);

tempRwidth = width / 2; % TODO: see with image not cutting correctly
tempRheight = height / 2;

% Pour être sûr de supprimer si 1 pixel en trop
if mod(tempRwidth,1) > 0.5
    Rwidth = uint32(tempRwidth) - 1;
else
    Rwidth = uint32(tempRwidth);
end

% Pour être sûr de supprimer si 1 pixel en trop
if mod(tempRheight,1) > 0.5
    Rheight = uint32(tempRheight) - 1;
else
    Rheight = uint32(tempRheight);
end

% On boucle sur les 4 Region
count = 1;
R = zeros(Rheight,Rwidth,4); % Pour de meilleur performance,
% pré-allocation et conversion en uint8 pour correspondre aux données
% de l'image

R(:,:,1) = imcrop(img, [1 1 Rwidth-1 Rheight-1]);
R(:,:,2) = imcrop(img, [Rwidth 1 Rwidth-1 Rheight-1]);
R(:,:,3) = imcrop(img, [1 Rheight Rwidth-1 Rheight-1]);
R(:,:,4) = imcrop(img, [Rwidth Rheight Rwidth-1 Rheight-1]);

for j = 0:1
    for i = 0:1
        % B = imcrop(A,[xmin ymin width height]);
        % On prendra successivement la Region en haut à gauche, droite; en
        % bas à gauche, droite
        imgc = imcrop(img, [i*Rwidth+(i*1) j*Rheight+(j*1) ...
            Rwidth-1 Rheight-1]);
        R(:,:,count) = imgc;
        count = count + 1;
    end
end
