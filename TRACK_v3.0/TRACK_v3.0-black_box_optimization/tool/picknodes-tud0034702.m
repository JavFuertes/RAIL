function [NodeNumber]=picknodes(range, NodeCoord)

index=NodeCoord(:,2)>=range(1) & NodeCoord(:,2) <=range(2);

NodeNumber=NodeCoord(index,:);
end