function [geo] = mesh_trk(in_data)
%Read in data
Ltot_R=in_data.geo.Ltot_R;                  %[m]
dist_R_betwSprings=in_data.geo.SlpSpc;      %[m]
numElem_R_betwSprings=in_data.mesh.numElem_R_betwSprings;   %Number of elements between 2 springs
dist_S=dist_R_betwSprings;                     %[m]
m_1S_Ext=in_data.mesh.m_1S_Ext;                %Number of elements in a sleeper external
m_1S_Int=in_data.mesh.m_1S_Int;                %Number of elements in a sleeper internal
LExt_S=in_data.geo.LExt_S;              %[m]
LInt_S=in_data.geo.LInt_S;              %[m]
dist_RS=in_data.geo.dist_RS;               %[m] Between rails and sleepers
dist_SB=in_data.geo.dist_SB;               %[m] Between sleepers and ballast

% clear in_data

%
m_Spring_RS=(Ltot_R/dist_R_betwSprings)-1; %number of springs between rail and sleeper
%

%
num_S=m_Spring_RS; %number of sleepers= number of springs between

%element length
%
LElem_R=Ltot_R/((numElem_R_betwSprings)*(m_Spring_RS+1)); %element length
LElem_S_Ext=LExt_S/m_1S_Ext; % length of extertal sleeper element
LElem_S_Int=LInt_S/m_1S_Int; % length of extertal sleeper element
%
%number of elements 
%
m_R=Ltot_R/LElem_R; %number of elements in RAIL
m_1S=m_1S_Ext+m_1S_Int; %number of elements in ONE SLEEPER
m_Stot=m_1S*num_S; %number of elements in ALL SLEEPERS
%
%number of nodes for rail and sleepers
%
numNodes_R=m_R+1;
numNodes_1S_Ext=m_1S_Ext+1;
numNodes_1S_Int=m_1S_Int+1;
numNodes_1S=m_1S+1;
numNodes_Stot=m_Stot+num_S;
numNodes_B=numNodes_Stot; % number of nodes for ballast equals to
numNodes=numNodes_R+numNodes_Stot+numNodes_B;
%
m_Spring_SB=numNodes_B;
m=m_R+m_Stot+m_Spring_RS+m_Spring_SB;
%
%Node coordinates for rail, sleeper and ballast
%
nodeCoord_R=[(0:LElem_R:Ltot_R);zeros(1,(m_R+1))]';
nodeCoord_S=zeros((m_1S+1)*m_Spring_RS,2);
for i=1:num_S
    nodeCoord_S(((i-1)*(numNodes_1S_Ext+numNodes_1S_Int-1))+(1:numNodes_1S_Ext),:)=...
        nodeCoord_S(((i-1)*(numNodes_1S_Ext+numNodes_1S_Int-1))+(1:numNodes_1S_Ext),:)+...
        [(i*dist_S-LExt_S:LElem_S_Ext:i*dist_S);(-ones(1,(m_1S_Ext+1)).*dist_RS)]';
    nodeCoord_S(((i-1)*(numNodes_1S_Ext+numNodes_1S_Int-1))+(numNodes_1S_Ext+1:numNodes_1S_Int+numNodes_1S_Ext-1),:)=...
        nodeCoord_S(((i-1)*(numNodes_1S_Ext+numNodes_1S_Int-1))+(numNodes_1S_Ext+1:numNodes_1S_Int+numNodes_1S_Ext-1),:)+...
        [(i*dist_S+LElem_S_Int:LElem_S_Int:i*dist_S+LInt_S);(-ones(1,(m_1S_Int)).*dist_RS)]';
end

nodeCoord_B=[nodeCoord_S(:,1),(-ones(1,numNodes_Stot).*(dist_RS+dist_SB))'];
nodeCoord=[nodeCoord_R;nodeCoord_S;nodeCoord_B]; %[x,y]
%
%Number of DOF for rail, sleeper and ballast
%
GDof_R=2*numNodes_R;
GDof_1S=2*numNodes_1S;
GDof_Stot=2*numNodes_Stot;
GDof_B=2*numNodes_B;
GDof=GDof_R+GDof_Stot+GDof_B;
%
%Specifying nodes numbers for each element
%
% elemNodes = zeros(m,2);
for i=1:m_R %Railway
    elemNodes(i,:)=[i,i+1];
end
for i=0:num_S-1 %Sleepers
    for i04=(i*numNodes_1S)+numNodes_R+1:(i*numNodes_1S)+m_R+numNodes_1S 
    elemNodes(length(elemNodes)+1,:)=[i04,i04+1];
    end
end
for i=1:num_S %Spring between Rail and Sleepers
    elemNodes(length(elemNodes)+1,:)=[(i*numElem_R_betwSprings)+1,(i*(m_1S+1))+numNodes_R-m_1S_Int];
end
for i=1:numNodes_Stot %Spring between Sleepers and Ballast
    elemNodes(length(elemNodes)+1,:)=[i+numNodes_R,i+numNodes_R+numNodes_Stot];
end
%
%Write to output
%
geo.ND = [1:length(nodeCoord);nodeCoord']';
geo.EL = [1:length(elemNodes);elemNodes']';
geo.LElem = [LElem_R,LElem_S_Ext,LElem_S_Int,dist_RS,dist_SB];
geo.NumEL = [m_R,m_1S_Ext,m_1S_Int,m_Stot,m_Spring_RS,m_Spring_SB,m];
geo.NumND = [numNodes_R,numNodes_1S_Ext,numNodes_1S_Int,numNodes_Stot,numNodes_B,numNodes];
geo.GDof = [GDof_R,GDof_1S,GDof_Stot,GDof_B,GDof];


end