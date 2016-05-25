function A = McAoperator(picks,D,n1,n2,N1,N2,rowSt,colSt,q)

A.times = @(x) xToy(x,picks,D,n1,n2,N1,N2,rowSt,colSt,q);
A.trans = @(y) yTox(y,picks,D,n1,n2,N1,N2,rowSt,colSt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = xToy(x,picks,D,n1,n2,N1,N2,rowSt,colSt,q)
K = size(D,2);
y = vPtRtFunc(D*reshape(x,K,q),n1,n2,N1,N2,rowSt,colSt);
y = y(picks);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = yTox(y,picks,D,n1,n2,N1,N2,rowSt,colSt)
x = zeros(N1,N2); x(picks) = y;
DtX = D'*vPtRFunc(x,n1,n2,N1,N2,rowSt,colSt);
x = DtX(:);