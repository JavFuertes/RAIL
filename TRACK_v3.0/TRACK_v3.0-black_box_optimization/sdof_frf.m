function [H,mag]=sdof_frf(frqEig,meq,dr,wi)
wd=2*pi*frqEig.*sqrt(1-dr.^2);
res=-1i*1./(2.*meq.*wd);
sigma=sqrt((2*pi*frqEig).^2-wd.^2);
p=-sigma+1i.*wd;
mag=abs(res./sigma);

% H=zeros(length(frqEig),length(wi));
for w=1:length(wi)
    H(:,:,w)=res./(wi(w)*1i-p)+conj(res)./(wi(w)*1i-conj(p));  
end
end
