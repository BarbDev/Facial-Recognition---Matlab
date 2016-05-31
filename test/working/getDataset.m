function [ D ] = getDataset( datasetName )
%getDat Get one of the available database
%   This function return a struct containing the image from the wished
%   database.
%   Argument:
%   NAME the name of the database to get
%      -chokepoint, colorferet, CroppedYale, ExtendedYaleB, ORL
%      Or put 'null' in case you want to select a database which is outside
%      the current folder.

%% Getting the supported file formats
form = imformats;
expression = '\w\.(';
for i = 1:size(form,2)
    if size(form(i).ext,2) > 1 % We have different extension for same format
        for j = 1:size(form(i).ext,2)
            if i~=1 || j~=1
                expression = strcat(expression,'|',form(i).ext(j));
            else
                expression = strcat(expression,form(i).ext(j));
            end
        end
    else
        if i~=1
            expression = strcat(expression,'|',form(i).ext);
        else
            expression = strcat(expression,form(i).ext);
        end
    end
end
expression = strcat(expression,')$');

%% Setting some default variable
% Adapt the separator according to the user system
if strcmp(getenv('OS'),'Windows_NT')
    separator = '\';
else
    separator = '/';
end
if regexp(datasetName, '^(chokepoint|colorferet|CroppedYale|ExtendedYaleB|ORL)$')
    datasetPath = [pwd separator 'database' separator 'dataset_' datasetName];
    if strcmp(datasetName, 'chokepoint')
        datasetPath = uigetdir(datasetPath,'Choose a database');
    elseif strcmp(datasetName, 'colorferet')
        error('Cannot use colorferet, not implemented yet')
        return;
    end
elseif strcmpi(datasetName, 'null')
    datasetPath = uigetdir(pwd,'Choose a database');
else
    error(['Database name: %s \nPlease check spelling (case sensitive)' ...
        'and your current folder if not using ''null'''], datasetName);
    return;
end

% Generic database case - means that the database is constructed as follow:
% The current directory contains several folders (class) which has
% different face shot.
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
        fileCount = 1;
        for j = 1:size(currentDir)
            if ~cellfun(@isempty, regexpi(currentDir(j).name, expression, 'start')) % si c une image
                D(dirCount).set(fileCount).name = currentDir(j).name;
                D(dirCount).set(fileCount).img(:,:) = double(imread([currentDirName separator D(dirCount).set(fileCount).name]));
                fileCount = fileCount + 1;
            end
        end
        dirCount = dirCount + 1;
    end
end
end