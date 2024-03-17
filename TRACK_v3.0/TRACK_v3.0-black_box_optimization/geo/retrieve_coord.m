function [nodeCoord_Rl,nodeCoord_Rr,nodeCoord_S,nodeCoord_B]=retrieve_coord(nodeCoord)
nodeCoord_Rl=nodeCoord(nodeCoord(:,4)==1,:);
nodeCoord_Rr=nodeCoord(nodeCoord(:,4)==2,:);
nodeCoord_S=nodeCoord(nodeCoord(:,4)==3,:);
nodeCoord_B=nodeCoord(nodeCoord(:,4)==4,:);

end
