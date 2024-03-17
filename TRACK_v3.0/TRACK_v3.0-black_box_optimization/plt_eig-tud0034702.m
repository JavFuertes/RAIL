function [NodeNumber, dofi, nodei,shape,Vshape]=plt_eig(V,geo,mat_trk,range,modenum,eigfrq,scale)
[NodeNumber]=picknodes(range, geo.ND); %define the node numbers to be plotted
[~,~,~,dofi,nodei]=time_history(NodeNumber,mat_trk.activeDof); %  get the reference index of the nodes to be plotted


Vshape=V(dofi,:);

shape=zeros(length(geo.ND),1);
shape(nodei)=Vshape(:,modenum);
plot_modeShape(geo,shape,scale); 
xlim('Auto');
 title([num2str(eigfrq(modenum)),' Hz'])
end
