dis_out=zeros(1001,1582);
dis_out(:,mat_trk.activeDof)=dis.r;
%
index=geo.ND(:,2)>14.3&geo.ND(:,2)<16.9;
%

node=geo.ND(index,:);
Lia=ismember(geo.EL(:,2:3),node(:,1));
geo1.EL=geo.EL(Lia(:,1),:);
ts=400:10:750;
geo1.ND=geo.ND;

figure;

frame(length(ts))=struct('cdata',[],'colormap',[]);
for i=1:length(ts)
geo1.ND(:,4)=geo.ND(:,4)+100*dis_out(ts(i),1:2:1582)';
plot_geo(geo1);
frame(i)=getframe;
close;
end
movie(frame,10,5);