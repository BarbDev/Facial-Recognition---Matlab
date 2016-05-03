%%% Example from
%%% http://au.mathworks.com/videos/face-recognition-with-matlab-100902.html

clear variables
close all
clc

%% Load Image Inforamation from ATT Face Database Directory
faceDatabase = imageSet('FaceDatabaseATT','recursive');

%% Display Montage of first Face
figure;
montage(faceDatabase(1).ImageLocation);
title('Images of Single Face');

%% Display Query Image and Database Side-Side
personToQuery = 1;
galleryImage = read(faceDatabase(personToQuery),1);
% Missing code

%% Split Database into Training & Test Sets
[training,test] = partition(faceDatabase,[0.8 0.2]);

%% Extract and display Histogram of Oriented Gradient Feature for single face
person = 5;
[hogFeature, visualization]= ...
    extractHOGFeatures(read(training(person),1));
figure;
subplot(2,1,1);imshow(read(training(person),1));title('Input Face');
subplot(2,1,2);plot(visualization);title('HoG Feature');

%% Extract HOG Features for training set
trainingFeatures = zeros(size(training,2)*training(1).Count,4680);
featureCount = 1;
for i = 1:size(training,2)
    for j = 1:training(i).Count
        trainingFeatures(featureCount,:) = extractHOGFeatures(read(training(i))); %, j'ai pas la suite
        trainingLabel{featureCount} = training(i).Description;
        featureCount = featureCount + 1;
    end
end

%% Create 40 class classifier using fitcecoc
faceClassifier = fitecoc(trainingFeatures,trainingLabel);