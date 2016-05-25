%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Algorithme de test
clear variables
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                VARIABLES
%
pSize = 8;
overflow = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dict = getDataset();

for i = 1:size(Dict,2) % Pour chaque 'class d'image'
    for j = 1:size(Dict(i).set, 2) % Pour chaque image d'une classe
        Rs = getRegions(Dict(i).set(j).img);
        for k = 1:4 % Pour chaque région d'une image
            patches = getPatches(Rs(:,:,k), pSize, overflow);
            patchNormDCT2 = normDct2(patches, true, true);
            lowFreq = getLowFreqComp(patchNormDCT2); % On a les 15 plus
            Class(i).img(j).R(k).patches = lowFreq;
            % petites valeurs positives et négative de chaque patchs
            
            % TODO générer sparse code pour chaque patch, ATTENTION
            % vérifier que c des positif, appliqué absolu, sinon foir avec
            % la méthode qui suit pour région descriptor
            
            % après génération sparse code, chaque région est décrite de la
            % façon suivante: hr = 1/Np * somme sparse vector de R
            % hr -> region descriptor
            % Np -> number of patch in current region
            % R -> current region
            
        end
    end
end

%%% Computing the image similarities used the methods from LSED [24]
% simi -> computed similaritie, assumed the lower the better the
% correspondance
% sumR -> the sum of the formula ||hr[A] - hr[B]||1
% sumR = ...
% simi = 1/Rnbr * sum