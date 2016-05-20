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
            %[pos, neg] = getLowFreqComp(patchNormDCT2); % On a les 15 plus
            % TODO: corriger ce truc
            Class(i).img(j).R(k).patches = patchNormDCT2;
            % petites valeurs positives et négative de chaque patchs
            
            % TODO générer sparse code pour
        end
    end
end