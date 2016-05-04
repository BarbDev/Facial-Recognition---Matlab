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
regions = getRegions(img);
R = regions(:,:,1);


f = 7
b = im2col(R,[2*f+1 2*f+1],'sliding');
db = dct(double(b));

imshow(b)
figure
imshow(db)