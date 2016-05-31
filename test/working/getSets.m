function [ No_Files_In_Class_Folder, Class, A, Test ] = getSets( Dict, pSize, overflow )
%GETSETS Summary of this function goes here
%   Detailed explanation goes here

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
            %%% IS it important to keep Class ? see if can get rid for less
            %%% memory usage
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

end

