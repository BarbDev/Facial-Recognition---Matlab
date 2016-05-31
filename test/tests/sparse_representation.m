%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Algorithme de test
clear variables
close all
clc

%%% Chargement du dictionnaire ?
% On a le repétoire de base
% On précise le répertoire de dataset
currDir = pwd;

if strcmp(getenv('OS'),'Windows_NT')
    separator = '\';
else
    separator = '/';
end
datasetPath = [currDir separator 'database' separator 'dataset_ORL'];

% Contenu du dataset
datasetContent = dir(datasetPath);
fileCount = 1;
Class_Count = 1;
for i = 1:size(datasetContent)
    % On test si c'est un dossier et pas '.' ou '..'
    objName = datasetContent(i).name;
    if datasetContent(i).isdir ...
            && ~strcmp(objName,'.') ...
            && ~strcmp(objName,'..')
        % On boucle maintenant dans le dossier contenant les images
        currentDirName = [datasetPath separator objName];
        currentDir = dir(currentDirName);
        
        for j = 3:size(currentDir) % pas de -2, on boucle jusqu'a la fin de l'index
            %temp = double(imread([currentDirName separator currentDir(j).name]));
            temp = double(imresize(imread([currentDirName separator currentDir(j).name]),[6 3]));
            D(:, fileCount) = temp(:);
            fileCount = fileCount + 1;
        end
        Class_Count = Class_Count+1;
    end
end
% A contains all the training image, 1colum = 1image
A = D;
% See page3 left paragraph l2norm
A = A/(diag(sqrt(diag(A'*A)))); % Learning ? idk wtf it does, just get lower coef, matrix still same size

%%% Début comparaison avec image de test
Test_Image_name = [datasetPath separator 's2' separator '1.pgm']
Test_Image = double(imresize(imread(Test_Image_name),[6 3]))
y = Test_Image(:); % image to be tested in column
n = size(A,2); % size of number of image (for n image)

f=ones(2*n,1); % Generate a colum full of one size 2*n ->2*number of image
Aeq=[A -A]; % concatenate the A matrix with his opposite -A, to the right
lb=zeros(2*n,1); % Generate a colum full of zeros size 2*n ->2*number of image
x1 = linprog(f,[],[],Aeq,y,lb,[],[],[]); % finds minimum of problem min x fTx {Aeq*x=y with lb <= x}
x1 = x1(1:n)-x1(n+1:2*n); % substract the 'left' side by the 'right' side, does it has something to do with Aeq =[A -A] ?
% On retourne donc au nbe d'image (400 dans notre cas)
No_Files_In_Class_Folder = [10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10]; % TODO: auto set it while reading dictionnarie
nn = No_Files_In_Class_Folder; % number of files per class folder
nn = cumsum(nn);
tmp_var = 0;
k1 = Class_Count-1;
for i = 1:k1
    delta_xi = zeros(length(x1),1);
    if i == 1
        % delta_xi(1:nbrImageInClass) equal the x1(1:nbrImageInClass)
        delta_xi(1:nn(i)) = x1(1:nn(i));
    else
        % temp_var = the old one + previous nn
        tmp_var = tmp_var + nn(i-1);
        
        begs = nn(i-1)+1;
        ends = nn(i);
        delta_xi(begs:ends) = x1(begs:ends);
    end
    tmp(i) = norm(y-A*delta_xi,2); % calculate norm 2 of the image matrix minus dictionnary A and the delta_xi
    % See page5 algo1: computing residual
    tmp1(i) = norm(delta_xi,1)/norm(x1,1); % substract the norm 1 of delta_xi by the norm1 of x1
end
Sparse_Conc_Index = (k1*max(tmp1)-1)/(k1-1); % Sparse code index, what ?? see page5 example2
clss = find(tmp==min(tmp)); % determine the class via minimum distance between ??
% la classe varie selon le nommage des dossier, matlab ne les trie pas de
% la même façon que windows ex: s1, s10, s11 etc... au lieu de s1,s2,s3

% cccc = dir([Training_Set_Folder]);
% Which_Folder = dir([Training_Set_Folder,cccc(clss+2).name,'\']);
% Which_Image = randsample(3:length(Which_Folder),1); % choose randomly ??
% Image_Path = [Training_Set_Folder,cccc(clss+2).name,'\',Which_Folder(Which_Image).name];
% Class_Image = (Image_Path);
