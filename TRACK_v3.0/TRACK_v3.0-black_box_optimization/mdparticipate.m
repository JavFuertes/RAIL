function [L,meff]=mdparticipate(V,M,dofi,dofn)
   
r=zeros(length(V),1);
for i=dofi:dofn:length(V)
r(i)=1;
end


L=V'*M*r;
meff=L.^2;
end