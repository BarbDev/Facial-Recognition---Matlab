%%% Script de chargement des images
clear variables
close all
clc

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
        
        % On lit la 1ere image d'avance pour récupérer caractéristique et
        % ainsi allouer mémoire avant.
        img = imread([currentDirName separator currentDir(3).name]); % démarre à 3 car les 2 1er sont '.' et '..'
        [imgHeight, imgWidth] = size(img);
        % -2 car on ne compte pas '.' et '..'
        imageSet = zeros(imgHeight, imgWidth, size(currentDir, 1)-2, 'uint8');
        
        D(dirCount).name = datasetContent(i).name;
        for j = 3:size(currentDir) % pas de -2, on boucle jusqu'a la fin de l'index
            D(dirCount).set(j-2).name = currentDir(j).name;
            D(dirCount).set(j-2).img(:,:) = imread([currentDirName separator D(dirCount).set(j-2).name]);
            %imageSet(:,:,j-2) = imread([currentDirName separator currentDir(j).name]);
        end
        %D(:,:,:,dirCount) = imageSet;
        dirCount = dirCount + 1;
    end
end