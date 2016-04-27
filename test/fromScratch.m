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
R = regions(:,:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                VARIABLES
%
Rsize = size(R);
Rsize = Rsize(1,1);
pSize = 8;
overflow = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Image carré avec patch carré
% On calcul le nombre de fois que l'on doit boucler
% On met l'overflow sur l'axe des abscisses
nbrC = Rsize / (pSize-overflow);
nbrR = Rsize / pSize;
patches = uint8(zeros(pSize*pSize,nbrR*uint8(nbrC))); % NE PAS METTRE EN
% DESSOUS DES LIGNES 'if decimal' CAR PREND EN COMPTE LA BONNE TAILLE
% voir -> uint8(nbrC)

% On va tous les faires sauf le dernier qui peut poser probleme
% On va boucler en descendant car c'est plus facile a retrouver l'image, on
% saura que la derniere colonne toutes entière est stocker dans les
% derniers vecteurs et donc plus facile à reconstruire
decimal = mod(nbrC,1);
toDoLast = false;
minusOne = false;
if decimal ~= 0
    toDoLast = true;
    if decimal >= 0.5
        nbrC = nbrC-1; % On garde le dernier pour une autre boucle
        minusOne = true;
    end
    % Sinon pas besoin d'enlever -1 car uint8 arrondi au nombre inférieur
end
patches(:,1) = reshape(imcrop(R, [1 1 pSize-1 pSize-1]), ...
            [pSize*pSize 1]);
count = 2;
for i = 1:nbrC-1
    for j = 1:nbrR-1
        x=1+i*(pSize-overflow);
        y=1+j*pSize;
        % Reshape so it is only in one column
        % Reshape store one colum after another
        patches(:,count) = reshape(imcrop(img, [x y pSize-1 pSize-1]), ...
            [pSize*pSize 1]);
        count = count + 1;
    end
end
if toDoLast
    % On doit boucler une fois de plus pour remplir le dernier espace
    % manquant
    666
    x=1+(nbrC+1)*(pSize-overflow) % Besoin du minusOne ?
    for i = 1:nbrR % On descend encore
        y=1+i*pSize;
        patches(:,count) = reshape(imcrop(R, [x y pSize-1 pSize-1]), ...
            [pSize*pSize 1]);
        count = count + 1;
    end
end