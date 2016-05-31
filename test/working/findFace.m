function [ clss, Sparse_Conc_Index ] = findFace( A, y, nn, classCount )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

n = size(A,2); % size of number of image (for n image)

f=ones(2*n,1); % Generate a colum full of one size 2*n ->2*number of image
Aeq=[A -A]; % concatenate the A matrix with his opposite -A, to the right
lb=zeros(2*n,1); % Generate a colum full of zeros size 2*n ->2*number of image
x1 = linprog(f,[],[],Aeq,y,lb,[],[],[]); % finds minimum of problem min x fTx {Aeq*x=y with lb <= x}
x1 = x1(1:n)-x1(n+1:2*n); % substract the 'left' side by the 'right' side, does it has something to do with Aeq =[A -A] ?
% On retourne donc au nbe d'image (400 dans notre cas)

% number of files per class folder
nn = cumsum(nn);
tmp_var = 0;
k1=classCount;
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

end

