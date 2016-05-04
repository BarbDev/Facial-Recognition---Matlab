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
        img = imread([currentDirName currentDir(1).name]);
        [imgHeight, imgWidth] = size(img);
        % -2 car on ne compte pas '.' et '..'
        imageSet = zeros(imgHeight, imgWidth, size(currentDir)-2, 'uint8');
        for j = 1:size(currentDir)-2
            imageSet(:,:,j) = imread([currentDirName currentDir(j).name]);
        end
    end
end