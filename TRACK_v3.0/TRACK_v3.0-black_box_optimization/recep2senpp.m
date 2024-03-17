function [M,fpp,spp]=recep2senpp(recep,fxx,para,seg)
ind=fxx>seg(1) & fxx<seg(2);
fxx1=fxx(ind);
for i=1:length(recep)
[M(i),I]=max(abs(recep(i).H1(ind)));
fpp(i)=fxx1(I);
end
val=fpp./fpp(2);
Fx=gradient(val,para);
spp=Fx(2);
end

