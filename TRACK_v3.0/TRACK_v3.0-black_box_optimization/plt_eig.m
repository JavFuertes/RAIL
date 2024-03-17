function [NodeNumber, dofi, nodei,shape,Vshape]=plt_eig(V,geo,mat_trk,range,modenum,eigfrq,scale,railOnly)
if nargin < 8
    railOnly = 0;
end
    
[NodeNumber]=picknodes(range, geo.ND); %define the node numbers to be plotted
[~,~,~,dofi,nodei]=time_history(NodeNumber(:,1),mat_trk.activeDof); %  get the reference index of the nodes to be plotted
elementi = ismember(geo.EL(:,2),nodei) & ismember(geo.EL(:,3),nodei);
geoShape.ND = geo.ND(nodei,:);
geoShape.EL = geo.EL(elementi,:);
Vshape=V(dofi,:);

shape=zeros(length(geo.ND),1);
shape(nodei)=Vshape(:,modenum);
plot_modeShape(geoShape,Vshape(:,modenum),scale,railOnly); 
xlim('Auto');
 title([num2str(round(eigfrq(modenum),1)),' Hz'])
end
