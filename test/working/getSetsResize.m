function [ No_Files_In_Class_Folder, A, Test ] = getSetsResize( Dict )
%GETSETS Summary of this function goes here
%   Detailed explanation goes here

imgCount = 1;
No_Files_In_Class_Folder = zeros(1,size(Dict,2));
%%% These are the training data
for i = 1:size(Dict,2) % Pour chaque 'class d'image'
    No_Files_In_Class_Folder(i) = uint16(size(Dict(i).set, 2))-3;
    for j = 1:No_Files_In_Class_Folder(i) % Pour chaque image d'une classe
        temp = imresize(Dict(i).set(j).img, [6 3]);
        A(:,imgCount) = temp(:);
        imgCount = imgCount + 1;
    end
end
%%% These are the test data
begJ = uint16(size(Dict(i).set, 2))-3;
for i = 1:size(Dict,2) % Pour chaque 'class d'image'
    for j = begJ+1:size(Dict(i).set, 2) % Pour chaque image d'une classe
        temp = imresize(Dict(i).set(j).img, [6 3]);
        Test(i).img(j-begJ).imgDescrip = temp(:);
    end
end
% Now that A contains all the stuff, we can copy the method from SRC
A = A/(diag(sqrt(diag(A'*A)))); % Learning ? idk wtf it does, just get lower coef, matrix still same size

end

