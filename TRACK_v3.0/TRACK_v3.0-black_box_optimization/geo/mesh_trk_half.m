%%
%Mesh full track, with two rails
%%
function [geo] = mesh_trk_half(beam_type_r,beam_type_s,nodeCoord)

[nodeCoord_Rl,nodeCoord_Rr,nodeCoord_S,nodeCoord_B]=retrieve_coord(nodeCoord);
%[nodeCoord_Rl,nodeCoord_Rr,nodeCoord_S,nodeCoord_B,nodeCoord]=node_coor(in_data);
geo.ND = [1:length(nodeCoord);nodeCoord']';

%%
%number of elements for each part
m_Rl=length(nodeCoord_Rl)-1;

m_R=m_Rl;
geo.sleeper(:,1)=unique(nodeCoord_S(:,1)); %x coordinates and number of elements  for each sleeper
for i=1:length(geo.sleeper)
    geo.sleeper(i,2)=length(find(nodeCoord_S(:,1)==geo.sleeper(i,1)))-1; %number of element in each sleeper
end
m_Stot=sum(geo.sleeper(:,2));
m_Spring_SB=length(nodeCoord_B);
m_Spring_RS=length(geo.sleeper);

m=m_R+m_Stot+m_Spring_SB+m_Spring_RS;

%%
% elements and corresponding
% [element number, node1,node2, partID, materialID, element type]
%Element type:
%          1     Euler beam
%          2     Timo beam
%          3     Spring/damper pair
%          4     Contact
%          5     Vehicle

elemNodes = zeros(m,5);

for i=1:m_Rl %left Rail
    elemNodes(i,:)=[i,i+1,1,1,beam_type_r];
    
end


for i=1:length(geo.sleeper) %Sleepers
    start_node=elemNodes(length(find(elemNodes(:,1))),2)+1;
    
    for j=start_node:start_node+geo.sleeper(i,2)-1
    elemNodes(length(find(elemNodes(:,1)))+1,:)=[j,j+1,3,2,beam_type_s];
    end
end
%Railpads Spring between Rail and Sleepers
numNode_r=length(nodeCoord_Rl);
index=ismember(round(geo.ND(1:numNode_r,2),8),round(geo.sleeper(:,1),8)); %find the node indexes for nodes of which x coordinates equals to sleepers
rabvs=geo.ND(index,1:3);

sleeperNodes=geo.ND(geo.ND(:,5)==3,:);
index1=ismember(round(sleeperNodes(:,3),8),-0.75);
% index2=ismember(round(sleeperNodes(:,3),8),0.75);
rabvs(:,4)=sleeperNodes(index1,1);


elemNodes(length(find(elemNodes(:,1)))+1:length(find(elemNodes(:,1)))+length(rabvs),:)=[rabvs(:,1),rabvs(:,4),4*ones(length(rabvs),1),3*ones(length(rabvs),1),3*ones(length(rabvs),1)];

%ballast
ballastNodes=geo.ND(geo.ND(:,5)==4,:);
elemNodes(length(find(elemNodes(:,1)))+1:length(find(elemNodes(:,1)))+length(ballastNodes),:)=[sleeperNodes(:,1),ballastNodes(:,1),5*ones(length(ballastNodes),1),4*ones(length(ballastNodes),1),3*ones(length(ballastNodes),1)];
%
%Write to output
%
%geo.ND = [1:length(nodeCoord);nodeCoord']';
geo.EL = [1:length(elemNodes);elemNodes']';
%geo.LElem = [LElem_R,LElem_S_Ext,LElem_S_Int,dist_RS,dist_SB];
geo.NumEL = [m_R,m_Stot,m_Spring_RS,m_Spring_SB,m];

% geo.NumND = [numNodes_R,numNodes_1S_Ext,numNodes_1S_Int,numNodes_Stot,numNodes_B,numNodes];
% geo.GDof = [GDof_R,GDof_1S,GDof_Stot,GDof_B,GDof];
%%
%BOUNDARY CONDITION
%
LeftRailNodes=geo.ND(geo.ND(:,5)==1,1);

%%%%%%%%%%%%%boundary condition for sleepers
SleeperNodes(:,1)=geo.ND(geo.ND(:,3)==0 & geo.ND(:,5)==3,1);%geo.ND(geo.ND(:,5)==3,1);%geo.ND(geo.ND(:,3)==0 & geo.ND(:,5)==3,1);
%%%%%%%%%%%%%can be disabled if necessary

geo.fixedNodeU=[LeftRailNodes(1);LeftRailNodes(length(LeftRailNodes));ballastNodes(:,1)];

%%%%%%%%%%%%%%%
geo.fixedNodeV=[LeftRailNodes(1);LeftRailNodes(length(LeftRailNodes));SleeperNodes(:,1);ballastNodes(:,1)];
% geo.fixedNodeV=[LeftRailNodes(1);LeftRailNodes(length(LeftRailNodes));ballastNodes(:,1)];
%%%%%%%%%%%%%%%%
end
%%

