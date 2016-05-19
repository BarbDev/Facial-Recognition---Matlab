%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Algorithme de test
clear variables
close all
clc

%vec = [-5;-9;-1;-3;-5;-41;2;6;9;4;-1;6;8;-9;10;2;3;4;-5;-3;1;45;2;-3;-1;2;4;-0.1;0.2;-0.123;-0.5;1.2;-1.3;0;0;6;1];
vec = [1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31];

%vec = sort(nonzeros(vec));
%vec = unique(nonzeros(vec)); % do unique ?
center = size(vec,1)/2; % Get column size (btw its only a column)
lowv = vec(uint8(center-7):uint8(center+7))