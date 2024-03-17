function [ ] = plotmdshp( NodeNumber, fixedNodeU, shape, factor)
%PLOTMDSHP Plot modal shapes 
%   Detailed explanation goes here
if nargin < 4
    factor=1;
end

index=~ismember(NodeNumber(:,1),fixedNodeU);
NN=NodeNumber(index,:);

NN(:,4)=NN(:,4)+factor*shape;

NodeRail=NN(NN(:,5)==1 | NN(:,5)== 2,:);
NodeSlp=NN(NN(:,5)==3,:);

[~,~,ic]=unique(NodeSlp(:,2));
N=histcounts(ic);

N=[0, N];




hold on

plot3(NodeRail(:,2),NodeRail(:,3),NodeRail(:,4),'Color','blue','Marker','o','MarkerSize',2);

for i= 1:length(N)-1
    a=sum(N(1:i))+1;
    b=a+N(i+1)-1;
    plot3(NodeSlp(a:b,2),NodeSlp(a:b,3),NodeSlp(a:b,4),'Color','blue','Marker','o','MarkerSize',2);
end




hold off

end

