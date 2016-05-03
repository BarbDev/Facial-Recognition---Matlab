function [ randoms ] = getRandom( nbrPatcheVoulu, pSize, RWidth, RHeight )
%GETRANDOM Return vector of random coordinates
%   Return a vector of size(2, nbrPatches), where each colum represent a
%   coordinate x and y
%   NBRPATCHESVOULU the number of coordinate you want
%   PSIZE the size of a patch (they are squares)
%   RWIDTH the width of the image from which we will get the patches
%   RHEIGHT the height of the image from which we will get the patches
%   The coordinates returned are the top-left of the patch and are
%   calculated so no patches are outside or over the edge of the image.

% Mise en place des intervalles
% On a un intervale pour la largeur et un autre pour la hauteur
% On va donc créé 2 vecteurs

aleaWidth = 1+(RWidth-pSize-1)*rand([1 nbrPatcheVoulu]);
aleaHeight = 1+(RHeight-pSize-1)*rand([1 nbrPatcheVoulu]);
randoms = zeros(2,nbrPatcheVoulu, 'uint32');
randoms(1,:) = aleaWidth;
randoms(2,:) = aleaHeight;

end

