function [M,senst]=recep2senmag(recep,fxx,para,seg)
M=zeros(size(seg));
for i=1:length(recep)
M(i,:)=interp1(fxx,abs(recep(i).H1),seg(i,:));

end
for j=1:size(seg,2)
val(:,j)=(M(:,j))./(M((length(recep)+1)/2,j));
end
[~,senst]=gradient(val,linspace(1,size(val,2),size(val,2)),para);

end