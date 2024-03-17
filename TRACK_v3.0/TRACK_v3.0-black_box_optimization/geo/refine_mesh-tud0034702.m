function [nodeCoord]=refine_mesh(start_coor,end_coor,elemLength,nodeCoord)
[nodeCoord_Rl,nodeCoord_Rr,nodeCoord_S,nodeCoord_B]=retrieve_coord(nodeCoord);

x1=start_coor(1);
y1=start_coor(2);
z1=start_coor(3);
x2=end_coor(1);
y2=end_coor(2);
z2=end_coor(3);

if z1==0 && z2==0 % nodes on rail
    if y1<0 && y2<0 %left rail
    k1=dsearchn(nodeCoord_Rl(:,1),x1);
    k2=dsearchn(nodeCoord_Rl(:,1),x2);
    b=(nodeCoord_Rl(k1,1)+elemLength:elemLength:nodeCoord_Rl(k2,1)-elemLength)';
    b=[b,nodeCoord_Rl(1:length(b),2:4)];
    nodeCoord_Rl=[nodeCoord_Rl(1:k1,:);b;nodeCoord_Rl(k2:length(nodeCoord_Rl),:)];
    
    elseif y1 > 0 && yw >0 %right rail
    k1=dsearchn(nodeCoord_Rr(:,1),x1);
    k2=dsearchn(nodeCoord_Rr(:,1),x2);
    b=(nodeCoord_Rr(k1,1)+elemLength:elemLength:nodeCoord_Rr(k2,1)-elemLength)';
    b=[b,nodeCoord_Rr(1:length(b),2:4)];
    nodeCoord_Rr=[nodeCoord_Rr(1:k1,:);b;nodeCoord_Rr(k2:length(nodeCoord_Rr),:)];
    
    end
elseif z1==-0.2 && z2==-0.2 && abs(x1-x2)<1e-7 % nodes on sleeper
     
    k1=dsearchn(nodeCoord_S(:,2),y1);
    k2=dsearchn(nodeCoord_S(:,2),y2);
    b=(nodeCoord_S(k1,2)+elemLength:elemLength:nodeCoord_S(k2,2)-elemLength)';
    b=[nodeCoord_S(1:length(b),1),b,nodeCoord_S(1:length(b),3:4)];
    nodeCoord_S=[nodeCoord_S(1:k1,:);b;nodeCoord_S(k2:length(nodeCoord_S),:)];
else
    display('Wrong input coordinates')
    
end

nodeCoord=[nodeCoord_Rl;nodeCoord_Rr;nodeCoord_S;nodeCoord_B];

end