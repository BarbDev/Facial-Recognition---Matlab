%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Algorithme de test
clear variables
close all
clc
img = imread('img.pgm');
%img = imread('cameraman.tif');
if size(img,3)==3 % Convertion en nuance de gris si RGB avant
   img = rgb2gray(img);
end
regions = getRegions(double(img));
R = regions(:,:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                VARIABLES
%
pSize = 8;
overflow = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

patches = getPatches(R, pSize, overflow);


patchNormDCT2 = patches;
patchNormDCT = patches;
patchDCT2 = patches;
patchDCT = patches;
[vSize, nbrFeature] = size(patchNormDCT2);
for i = 1:nbrFeature
    %% On normalise les patches pour avoir 'zero mean and unit variance'
    patchNormDCT2(:,i) = normDct2(patchNormDCT2(:,i), pSize, true);
    patchNormDCT(:,i) = normDct(patchNormDCT(:,i), true);
    %% On ne normalise pas (pour comparaison)
    patchDCT2(:,i) = normDct2(patchDCT2(:,i), pSize, false);
    patchDCT(:,i) = normDct(patchDCT(:,i), false);
end

% %% 'select the 15 lower frequency components of the DCT coefficients'
% % Pour chaque patch on ne garde que les 15 coef les + petits (c ça?)
% for i = 1:nbrFeature
%     vector = sort(normPatch(:,i));
%     % Ici on enlève tous les 0 et on garde les 15 plus petit
%     % ??? Que faire s'il y a moins de 15coef supérieur à 0?
%     %%% Que faut il choisir ? doublon ou pas ?
%     %vector = nonzeros(vector); % On garde que les coef > 0
%     vector = unique(vector); % On garde que les coefs > 0 et pas de doublon
%     if size(vector) < 15 % On garde les 15 premier ou -
%         vector = vector(1:end);
%     else
%         vector = vector(1:15);
%     end
%     %TODO Bug, pas la même taille...
%     normPatch(:,i) = vector;
% end


%% Affichage résultat recontruction image à partir des patchs
figure('Name', 'DCT & DCT2 comparison')
subplot(3,2,[1 2])
imgPatch = getImgFromPatches(patches, size(R), overflow);
imshow(imgPatch)

%% Affichage résultats DCT
imgPatchDCT = getImgFromPatches(patchDCT, size(R), overflow);
subplot(3,2,3)
imshow(imgPatchDCT)
title('DCT without normalization')
imgPatchNormDCT = getImgFromPatches(patchNormDCT, size(R), overflow);
subplot(3,2,4)
imshow(imgPatchNormDCT)
title('DCT with normalization')

%% Affichage résultats DCT2
imgPatchDCT2 = getImgFromPatches(patchDCT2, size(R), overflow);
subplot(3,2,5)
imshow(imgPatchDCT2)
title('DCT2 without normalization')
imgPatchNormDCT2 = getImgFromPatches(patchNormDCT2, size(R), overflow);
subplot(3,2,6)
imshow(imgPatchNormDCT2)
title('DCT2 with normalization')