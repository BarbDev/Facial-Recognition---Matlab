function A = CircAoperator(picks,V,L,D,n1,n2,N1,N2,rowSt,colSt,q)

A.times = @(x) xToy(x,picks,V,L,D,n1,n2,N1,N2,rowSt,colSt,q);
A.trans = @(y) yTox(y,picks,V,L,D,n1,n2,N1,N2,rowSt,colSt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = xToy(x,picks,V,L,D,n1,n2,N1,N2,rowSt,colSt,q)
K = size(D,2);
y = vPtRtFunc(D*reshape(x,K,q),n1,n2,N1,N2,rowSt,colSt);
y = y./L;
y = fft2(V.*ifft2(y));
y = y(picks);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = yTox(y,picks,V,L,D,n1,n2,N1,N2,rowSt,colSt)
x = zeros(N1,N2); x(picks) = y;
x = fft2(conj(V).*ifft2(x));
x = x./L;
DtX = D'*vPtRFunc(x,n1,n2,N1,N2,rowSt,colSt);
x = DtX(:);

