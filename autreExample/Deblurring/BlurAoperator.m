function A = BlurAoperator(blur_kernel,D,n1,n2,N1,N2,rowSt,colSt,q)

[t,s] = size(blur_kernel);
t = floor(t/2); s = floor(s/2);
v = zeros(N1,N2);
v(floor(N1/2)+1-t:floor(N1/2)+1+t,floor(N2/2)+1-s:floor(N2/2)+1+s) = blur_kernel;

V = psf2otf(v);
A.times = @(x) xToy(x,V,D,n1,n2,N1,N2,rowSt,colSt,q);
A.trans = @(y) yTox(y,V,D,n1,n2,N1,N2,rowSt,colSt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = xToy(x,V,D,n1,n2,N1,N2,rowSt,colSt,q)
K = size(D,2);
y = vPtRtFunc(D*reshape(x,K,q),n1,n2,N1,N2,rowSt,colSt);
y = ifft2(V.*fft2(y));
y = y(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = yTox(y,V,D,n1,n2,N1,N2,rowSt,colSt)
y = reshape(y,N1,N2);
x = ifft2(conj(V).*fft2(y));
DtX = D'*vPtRFunc(x,n1,n2,N1,N2,rowSt,colSt);
x = DtX(:);