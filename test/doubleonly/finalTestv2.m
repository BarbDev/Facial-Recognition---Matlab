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
img = double(img); % REALLY IMPORTANT
regions = getRegions(img);
R = regions(:,:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                VARIABLES
%
pSize = 8;
overflow = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
patches = getPatches(R, pSize, overflow);

patchDCT2 = normDct2(patches, false, false);
patchMeanDCT2 = normDct2(patches, true, false);
patchVarDCT2 = normDct2(patches, false, true);
patchNormDCT2 = normDct2(patches, true, true);

%% Affichage résultat recontruction image à partir des patchs
figure('Name', 'DCT2 comparison')
subplot(2,5,[1 6])
imgPatch = getImgFromPatches(patches, size(R), overflow);
imshow(imgPatch, [0 255])
title('NO DCT2')

%% Affichage résultats DCT2
imgPatchDCT2 = getImgFromPatches(patchDCT2, size(R), overflow);
subplot(2,5,2)
imshow(imgPatchDCT2)
title('DCT2 without normalization')

imgPatchMeanDCT2 = getImgFromPatches(patchMeanDCT2, size(R), overflow);
subplot(2,5,3)
imshow(imgPatchMeanDCT2)
title('DCT2 with zero-mean')

imgPatchVarDCT2 = getImgFromPatches(patchVarDCT2, size(R), overflow);
subplot(2,5,4)
imshow(imgPatchVarDCT2)
title('DCT2 with zero-variance')

imgPatchNormDCT2 = getImgFromPatches(patchNormDCT2, size(R), overflow);
subplot(2,5,5)
imshow(imgPatchNormDCT2)
title('DCT2 with normalization')

%% Affichage résultats reconvertit en image -> idct2
subplot(2,5,7)
imshow(getImgFromDCTPatches(patchDCT2, size(R), overflow), [0 255]) % Without mean applied, have to precise display range
title('simple IDCT2')

subplot(2,5,8)
imshow(getImgFromDCTPatches(patchMeanDCT2, size(R), overflow))
title('IDCT2 with zero-mean')

subplot(2,5,9)
imshow(getImgFromDCTPatches(patchVarDCT2, size(R), overflow), [0 255]) % Without mean applied, have to precise display range
title('IDCT2 with zero-variance')

subplot(2,5,10)
imshow(getImgFromDCTPatches(patchNormDCT2, size(R), overflow))
title('IDCT2 with norm')