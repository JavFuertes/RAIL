function [nodeCoord]=node_coor(in_data, halftrack)
%%
% function to calculate node coordinate based on input data
% Node coordinates for left rail, right rail, sleepers and ballast are
% output in 4 matrix.
% Each matrix includes 4 columns, representing x,y,z-coordinate and
% identifier, respectively.
% The identifiers are defined as
%                1        nodes on left rail
%                2        nodes on right rail
%                3        nodes on sleepers
%                4        nodes on ballast/ground
%%
if nargin <2
    halftrack=0;
end
%Read in data
Ltot_R=in_data.geo.Ltot_R;                  %[m]
dist_R_betwSprings=in_data.geo.SlpSpc;      %[m]
numElem_R_betwSprings=in_data.mesh.numElem_R_betwSprings;   %Number of elements between 2 springs
dist_S=dist_R_betwSprings;                     %[m]
m_1S_Ext=in_data.mesh.m_1S_Ext;                %Number of elements in a sleeper external
m_1S_Int=in_data.mesh.m_1S_Int;                %Number of elements in a sleeper internal
LExt_S=in_data.geo.LExt_S;              %[m]
LInt_S=in_data.geo.TrackWidth;              %[m]
dist_RS=in_data.geo.dist_RS;               %[m] Between rails and sleepers
dist_SB=in_data.geo.dist_SB;               %[m] Between sleepers and ballast

% clear in_data
%%
%
m_Spring_RS=(Ltot_R/dist_R_betwSprings)+1; %number of springs between ONE rail and sleeper
%

%
num_S=m_Spring_RS; %number of sleepers= number of springs between

%element length
%
LElem_R=Ltot_R/((numElem_R_betwSprings)*(m_Spring_RS-1)); %element length
LElem_S_Ext=LExt_S/m_1S_Ext; % length of extertal sleeper element
LElem_S_Int=LInt_S/m_1S_Int; % length of extertal sleeper element
%
%number of elements 
%
m_R=Ltot_R/LElem_R; %number of elements in ONE RAIL
m_1S=m_1S_Ext*2+m_1S_Int; %number of elements in ONE SLEEPER
m_Stot=m_1S*num_S; %number of elements in ALL SLEEPERS
%
%number of nodes for rail and sleepers
%
numNodes_R=m_R+1; %number of nodes in ONE RAIL
numNodes_1S_Ext=m_1S_Ext+1;
numNodes_1S_Int=m_1S_Int+1;
numNodes_1S=m_1S+1;
numNodes_Stot=m_Stot+num_S;
numNodes_B=numNodes_Stot; % number of nodes for ballast equals to
numNodes=numNodes_R+numNodes_Stot+numNodes_B;
%number of elements
m_Spring_SB=numNodes_B;
m=m_R*2+m_Stot+m_Spring_RS+m_Spring_SB;
%
%Node coordinates for rail, sleeper and ballast
%
nodeCoord_Rl=[(0:LElem_R:Ltot_R);-LInt_S/2.*ones(1,(m_R+1));zeros(1,(m_R+1));ones(1,(m_R+1))]';
nodeCoord_Rr=[(0:LElem_R:Ltot_R);LInt_S/2.*ones(1,(m_R+1));zeros(1,(m_R+1));2*ones(1,(m_R+1))]';
nodeCoord_S=zeros(numNodes_1S*num_S,3);
for i=1:num_S
    index=numNodes_1S*(i-1)+1:numNodes_1S*i;
    nodeCoord_S(index,2)= [-LExt_S-LInt_S/2:LElem_S_Ext:-LInt_S/2,-LInt_S/2+LElem_S_Int:LElem_S_Int:LInt_S/2,LInt_S/2+LElem_S_Ext:LElem_S_Ext:LExt_S+LInt_S/2]';
    nodeCoord_S(index,1)= (i-1)*dist_S;
    nodeCoord_S(index,3)= -1*dist_RS;
    nodeCoord_S(index,4)= 3;
end

nodeCoord_B=nodeCoord_S;
nodeCoord_B(:,3)=-2*dist_RS;
nodeCoord_B(:,4)=4;

nodeCoord=[nodeCoord_Rl;nodeCoord_Rr;nodeCoord_S;nodeCoord_B]; %[x,y]
if halftrack==1
    nodeCoord_S=nodeCoord_S(round(nodeCoord_S(:,2),5)<=0,:);
    nodeCoord_B=nodeCoord_S;
    nodeCoord_B(:,3)=-2*dist_RS;
    nodeCoord_B(:,4)=4;
    nodeCoord=[nodeCoord_Rl;nodeCoord_S;nodeCoord_B]; 
end