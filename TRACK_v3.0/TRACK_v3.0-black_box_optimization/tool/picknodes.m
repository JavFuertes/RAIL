function [NodeNumber]=picknodes(range, NodeCoord, type)
if nargin < 3
index=NodeCoord(:,2)>=range(1) & NodeCoord(:,2) <=range(2);
else
index1 = NodeCoord(:,2)>=range(1) & NodeCoord(:,2) <=range(2);
index2 = NodeCoord(:,5) == type; % !! NodeCoord should be geo.ND so that this line works
index = index1 & index2;
% TODO: if 'type' is a vector containing more than one part of the track system 
end

NodeNumber=NodeCoord(index,:);
end