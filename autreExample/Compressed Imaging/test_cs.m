%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file tests our method for compressed imaging
clear; close all;

load LearnDict;

n = size(Dl_lam_08,1);

D = [ones(n,1),Dl_lam_08];

load buildmat;

K = size(D,2);
[N1,N2] = size(X);

n1 = 8; n2 = 8;

m = round(0.20*N1*N2); % take 20% random samples

StPt = [1 1; 1 5; 5 1]; % three different partitions
StPt_num = 3;
Xrec = cell(1,StPt_num);

psnr = zeros(1,StPt_num);


picks = randsample(N1*N2,m);

% M is a kernel
M = randn(N1,N2)+1i*randn(N1,N2); V = fft2(M);

% normalize the circulant operator
L = spGetNrm(picks,real(M),imag(M),N1,N2,m);
L = L.^0.5; L = reshape(L,N1,N2);

b = fft2(V.*(ifft2(X./L))); b = b(picks);
nois = randn(m,1);

% add 1% noise
sig = 0.01*max(abs(b))/max(abs(nois));
b = b+sig*nois;


for num = 1:StPt_num
    
    rowSt = StPt(num,1); colSt = StPt(num,2);
    
    sgn1 = 0; sgn2 = 0;
    
    rowN = floor((N1-rowSt+1)/n1); colN = floor((N2-colSt+1)/n2);
    res1 = N1-rowSt+1-rowN*n1; res2 = N2-colSt+1-colN*n2;
    if res1 > 0        sgn1 = 1;      end
    if res2 > 0        sgn2 = 1;      end
    q = rowN*colN+sgn1*colN+sgn2*rowN+sgn1*sgn2;
    if rowSt > 1
        q = q + colN + sgn2;
    end
    
    if colSt > 1
        q = q + rowN + sgn1;
    end
    
    A = CircAoperator(picks,V,L,D,n1,n2,N1,N2,rowSt,colSt,q);
    
    opts = []; opts.maxit = 1000; opts.tol = 1e-4;
    opts.rho = sig;
    opts.x0 = randn(K*q,1);
    opts.weights = [zeros(1,q);ones(K-1,q)];
    opts.weights = opts.weights(:);
    x = yall1(A,b,opts);
    Xrec{num} = vPtRtFunc(D*reshape(x,K,q),n1,n2,N1,N2,rowSt,colSt);
end

% taking average over three recovered images
Xav = zeros(N1,N2);
for i = 1:StPt_num
    Xav = Xav + Xrec{i};
end
Xav = Xav/StPt_num;
psnr = measerr(X,Xav,max(X(:)));
imshow(Xav);
disp(psnr);