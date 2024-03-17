function [h1,h2,coh]=transf_fun(x,y)
h1=y.*conj(x)./(x.*conj(x));
h2=y.*conj(y)./(x.*conj(y));
coh=h1./h2;
end