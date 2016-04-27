% Algorithme de test
clear variables
close all
clc

img = imread('img.pgm');
if size(img,3)==3 % Convertion en nuance de gris si RGB avant
   img = rgb2gray(img);
end
figure('Name','Step 1: Original image','NumberTitle','off')
imshow(img)

% On prend des bouts d'image pour appliquer la DCT sur chacun d'eux
% On découpe l'image en 4 (Region R), chaque partie va ensuite encore
% découpé en plus petit morceaux (Patch P).
% Chaque Patch est normalisé pour prendre en compte la variation de
% contrast et ainsi avoir 'zero mean and unit variance'
%
% Taille des Patches (8x8 avec orverlap -> 6x8 ou 8x6)

% Lecture de la taille de l'image
[width, height] = size(img);

Rwidth = width / 2;
Rheight = height / 2;

% On boucle sur les 4 Region
figure('Name','Step 2: Original image cut in 4','NumberTitle','off')
count = 1;
R = uint8(zeros(Rwidth,Rheight,4)); % Pour de meilleur performance,
% pré-allocation et conversion en uint8 pour correspondre aux données
% de l'image
for j = 0:1
    for i = 0:1
        % B = imcrop(A,[xmin ymin width height]);
        % On prendra successivement la Region en haut à gauche, droite; en
        % bas à gauche, droite
        R(:,:,count) = imcrop(img, [i*Rwidth+(i*1) j*Rheight+(j*1) ...
            Rwidth Rheight]);
        subplot(2,2,count)
        imshow(R(:,:,count))
        count = count + 1;
    end
end

% Pour chaque Region il faut maintenant extraire les DCT des Patches
% Chaque Patches aura une taille de 8x8 pixels et sera décalé de 6 afin
% de déborder sur le précédent.
% On décide de déborder par 6x8

count = 1; % IMPORTANT
nbrRow = Rheight/8;
nbrCol = Rwidth/6;
% Réprésente tous les Patches de la Region
P = uint8(zeros(8,8,nbrRow*nbrCol));
Pimg = uint8(zeros(48,48));
PimgDCT = uint8(zeros(48,48));
figure('Name','Step 3: Patches + Patches with normalization and DCT',...
    'NumberTitle','off')
for j = 0:nbrRow-1 % -1 car on part de 0
    for i = 0:nbrCol % <--- débordement
        x=1+i*5;
        y=1+j*8;
        P(:,:,count) = imcrop(R(:,:,1), [x y 7 7]);
        Pimg(y:y+7,x:x+7) = P(:,:,count);
        % Normalisation des patchs avant DCT
        % (Mieux pour prendre en compte le contrast et l'exposition)
        img = uint8(255*mat2gray(img));
        PimgDCT(y:y+7,x:x+7) = dct2(P(:,:,count));
        count = count + 1;
    end
end
testP = getPatches(R(:,:,1), 8, 2);
subplot(1,2,1)
imshow(Pimg)
subplot(1,2,2)
imshow(PimgDCT)