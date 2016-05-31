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

%Dict = getDataset('CroppedYale');
Dict = getDataset('ORL');

% [ No_Files_In_Class_Folder, Class, A, Test ] = getSets(Dict, pSize, overflow);
[ No_Files_In_Class_Folder, A, Test ] = getSetsResize( Dict );

[ clss, Sparse_Conc_Index ] = findFace( A, Test(1).img(1).imgDescrip, No_Files_In_Class_Folder, size(Dict,2));