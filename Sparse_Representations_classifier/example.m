X=rand(15,20);
labels=[-ones(4,1);2*ones(5,1);3*ones(6,1)];
Y=rand(10,20);
%A=sparse_represent(Y,X,0.3);
[predictions,src_scores]=src(X,labels,Y,0.3)