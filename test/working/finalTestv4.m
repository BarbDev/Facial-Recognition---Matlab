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

Dict = getDataset('ORL');
imgCount = 1;
No_Files_In_Class_Folder = zeros(1,size(Dict,2));
%%% These are the training data
for i = 1:size(Dict,2) % Pour chaque 'class d'image'
    No_Files_In_Class_Folder(i) = uint16(size(Dict(i).set, 2))/2;
    for j = 1:No_Files_In_Class_Folder(i) % Pour chaque image d'une classe
        Rs = getRegions(Dict(i).set(j).img); 
        for k = 1:4 % Pour chaque région d'une image
            patches = getPatches(Rs(:,:,k), pSize, overflow);
            patchNormDCT2 = normDct2(patches, true, true);
            % Line below does not affect time spent, dont waste time on
            % optimizing the allocation
            % Get description of one vector
            Class(i).img(j).R(k).descriptor = 1/size(patchNormDCT2,2)*sum(getLowFreqComp(patchNormDCT2),2);
        end
        Class(i).img(j).imgDescrip = zeros(15,1);
        for k = 1:4
            % Once we got all the descriptor we add them to create the img
            % descriptor
            Class(i).img(j).imgDescrip = Class(i).img(j).R(k).descriptor + Class(i).img(j).imgDescrip;
        end
        A(:,imgCount) = Class(i).img(j).imgDescrip;
        imgCount = imgCount + 1;
    end
end
%%% These are the test data
begJ = uint16(size(Dict(i).set, 2))/2;
for i = 1:size(Dict,2) % Pour chaque 'class d'image'
    for j = begJ+1:size(Dict(i).set, 2) % Pour chaque image d'une classe
        Rs = getRegions(Dict(i).set(j).img); 
        for k = 1:4 % Pour chaque région d'une image
            patches = getPatches(Rs(:,:,k), pSize, overflow);
            patchNormDCT2 = normDct2(patches, true, true);
            % Line below does not affect time spent, dont waste time on
            % optimizing the allocation
            % Get description of one vector
            Test(i).img(j-begJ).R(k).descriptor = 1/size(patchNormDCT2,2)*sum(getLowFreqComp(patchNormDCT2),2);
        end
        Test(i).img(j-begJ).imgDescrip = zeros(15,1);
        for k = 1:4
            % Once we got all the descriptor we add them to create the img
            % descriptor
            Test(i).img(j-begJ).imgDescrip = Test(i).img(j-begJ).R(k).descriptor + Test(i).img(j-begJ).imgDescrip;
        end
    end
end


% Now that A contains all the stuff, we can copy the method from SRC
A = A/(diag(sqrt(diag(A'*A)))); % Learning ? idk wtf it does, just get lower coef, matrix still same size

%%% Début comparaison avec image de test
y = Test(3).img(3).imgDescrip; % image to be tested
n = size(A,2); % size of number of image (for n image)

f=ones(2*n,1); % Generate a colum full of one size 2*n ->2*number of image
Aeq=[A -A]; % concatenate the A matrix with his opposite -A, to the right
lb=zeros(2*n,1); % Generate a colum full of zeros size 2*n ->2*number of image
x1 = linprog(f,[],[],Aeq,y,lb,[],[],[]); % finds minimum of problem min x fTx {Aeq*x=y with lb <= x}
x1 = x1(1:n)-x1(n+1:2*n); % substract the 'left' side by the 'right' side, does it has something to do with Aeq =[A -A] ?
% On retourne donc au nbe d'image (400 dans notre cas)

%No_Files_In_Class_Folder = [10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10]; % TODO: auto set it while reading dictionnarie
nn = No_Files_In_Class_Folder; % number of files per class folder
nn = cumsum(nn);
tmp_var = 0;
%k1 = Class_Count-1;
k1=size(Dict,2);
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