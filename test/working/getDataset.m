function [ D ] = getDataset( )
%GETLOWFREQCOMP Summary of this function goes here
%   Detailed explanation goes here

% On a le repétoire de base
% On précise le répertoire de dataset
datasetName = 'database';
currDir = pwd;

if strcmp(getenv('OS'),'Windows_NT')
    separator = '\';
else
    separator = '/';
end
datasetPath = [currDir separator datasetName];

% Contenu du dataset
datasetContent = dir(datasetPath);
dirCount = 1;
for i = 1:size(datasetContent)
    % On test si c'est un dossier et pas '.' ou '..'
    objName = datasetContent(i).name;
    if datasetContent(i).isdir ...
            && ~strcmp(objName,'.') ...
            && ~strcmp(objName,'..')
        % On boucle maintenant dans le dossier contenant les images
        currentDirName = [datasetPath separator objName];
        currentDir = dir(currentDirName);
        
        D(dirCount).name = datasetContent(i).name; % TODO: pre-allocation pour meilleur perf
        for j = 3:size(currentDir) % pas de -2, on boucle jusqu'a la fin de l'index
            D(dirCount).set(j-2).name = currentDir(j).name;
            D(dirCount).set(j-2).img(:,:) = double(imread([currentDirName separator D(dirCount).set(j-2).name]));
        end
        %D(:,:,:,dirCount) = imageSet;
        dirCount = dirCount + 1;
    end
end
end