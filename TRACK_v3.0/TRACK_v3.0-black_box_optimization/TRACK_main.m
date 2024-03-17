%
clear
clc
format short;
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT DATA 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE STUDY DATA
Ltot_R=65;                  %[m]
dist_R_betwSprings=0.65;      %[m] 
numElem_R_betwSprings=3;   %Number of elements between 2 springs
dist_S=dist_R_betwSprings; %[m] 
m_1S_Ext=1;                %Number of elements in a sleeper external
m_1S_Int=3;                %Number of elements in a sleeper internal
LExt_S=0.430;              %[m]
LInt_S=0.750;              %[m]
Ltot_S=1.18;               %[m] half length (full length=2.36[m])
dist_RS=0.2;               %[m] Between rails and sleepers
dist_SB=0.2;               %[m] Between sleepers and ballast
F=[-150e3 0 0 0]';        %[N] in the Rail
n=4;                      %Node's number in which there's the F(1,1)
t1=1;                     %Number of time iterations
t2=0.1;                   %Time steps
%MATERIAL RAIL DATA 
E_R=210e9;     %[N/m^2]
I_R=3.0383e-5; %[m^4]
A_R=7.62e-3;   %[m^3]
rho_R=7800;    %[kg/m^3]
%MATERIAL SLEEPERS DATA 
E_S=64e9;     %[N/m^2]
I_S=1.75e-4;  %[m^4]
A_S=5.138e-2; %[m^3]
rho_S=3070;   %[kg/m^3]
%MATERIAL SPRING DATA 
K_Spring_RS=150e6; %[N/m]
K_Spring_SB=4e6;  %[N/m]
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GEOMETRY AND MESH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EI_R=E_R*I_R;
Arho_R=A_R*rho_R;
EI_S=E_S*I_S;
Arho_S=A_S*rho_S;
%
m_Spring_RS=(Ltot_R/dist_R_betwSprings)-1; %number of springs between rail and sleeper
%
LElem_R=Ltot_R/((numElem_R_betwSprings)*(m_Spring_RS+1)); %element length
%
num_S=m_Spring_RS; %number of sleepers= number of springs between
%
m_R=Ltot_R/LElem_R; %number of elements in RAIL
m_1S=m_1S_Ext+m_1S_Int; %number of elements in ONE SLEEPER
m_Stot=m_1S*num_S; %number of elements in ALL SLEEPERS
%
LElem_S_Ext=LExt_S/m_1S_Ext; % length of extertal sleeper element
LElem_S_Int=LInt_S/m_1S_Int; % length of extertal sleeper element
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
%
%Node coordinates for rail, sleeper and ballast
%
nodeCoord_R=[(0:LElem_R:Ltot_R);zeros(1,(m_R+1))]';
nodeCoord_S=zeros((m_1S+1)*m_Spring_RS,2);
for i01=1:num_S
    nodeCoord_S(((i01-1)*(numNodes_1S_Ext+numNodes_1S_Int-1))+(1:numNodes_1S_Ext),:)=...
    nodeCoord_S(((i01-1)*(numNodes_1S_Ext+numNodes_1S_Int-1))+(1:numNodes_1S_Ext),:)+...
    [(i01*dist_S-LExt_S:LElem_S_Ext:i01*dist_S);(-ones(1,(m_1S_Ext+1)).*dist_RS)]';
    nodeCoord_S(((i01-1)*(numNodes_1S_Ext+numNodes_1S_Int-1))+(numNodes_1S_Ext+1:numNodes_1S_Int+numNodes_1S_Ext-1),:)=...
    nodeCoord_S(((i01-1)*(numNodes_1S_Ext+numNodes_1S_Int-1))+(numNodes_1S_Ext+1:numNodes_1S_Int+numNodes_1S_Ext-1),:)+...
    [(i01*dist_S+LElem_S_Int:LElem_S_Int:i01*dist_S+LInt_S);(-ones(1,(m_1S_Int)).*dist_RS)]';
end
nodeCoord_S;
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
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%FORMING STIFFNESS DAMPING MASS FORCE MATRIX%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initial vectors and matrices with zeros
stiffness=zeros(GDof,GDof);
mass=zeros(GDof,GDof);
%Force vector for 1 element
F1=F.*[LElem_R*2 LElem_R^2*12 LElem_R*2 -LElem_R^2*12]';
%Stiffness matrix for 1 element of rail
K1_R=EI_R/(LElem_R)^3*[12        6*LElem_R   -12        6*LElem_R
                       6*LElem_R 4*LElem_R^2 -6*LElem_R 2*LElem_R^2
                       -12       -6*LElem_R  12         -6*LElem_R
                       6*LElem_R 2*LElem_R^2 -6*LElem_R 4*LElem_R^2];
%Stiffness matrix for 1 element of sleepers External
K1_S_Ext=EI_S/(LElem_S_Ext)^3*[12            6*LElem_S_Ext   -12            6*LElem_S_Ext
                               6*LElem_S_Ext 4*LElem_S_Ext^2 -6*LElem_S_Ext 2*LElem_S_Ext^2
                               -12           -6*LElem_S_Ext  12             -6*LElem_S_Ext
                               6*LElem_S_Ext 2*LElem_S_Ext^2 -6*LElem_S_Ext 4*LElem_S_Ext^2];
%Stiffness matrix for 1 element of sleepers Internal
K1_S_Int=EI_S/(LElem_S_Int)^3*[12            6*LElem_S_Int   -12            6*LElem_S_Int
                               6*LElem_S_Int 4*LElem_S_Int^2 -6*LElem_S_Int 2*LElem_S_Int^2
                               -12           -6*LElem_S_Int  12             -6*LElem_S_Int
                               6*LElem_S_Int 2*LElem_S_Int^2 -6*LElem_S_Int 4*LElem_S_Int^2];
%Stiffness matrix for the spring between rail and sleepers
K1_Spring_RS=K_Spring_RS*[1  0 -1 0
                          0  0 0  0
                          -1 0 1  0
                          0  0 0  0];
%Stiffness matrix for the spring between sleepers and ballast
K1_Spring_SB=K_Spring_SB*[1  0 -1 0
                          0  0 0  0
                          -1 0 1  0
                          0  0 0  0];
%Mass matrix for 1 element of rail
M1_R=((Arho_R*LElem_R)/420)*[156         22*LElem_R   54          -13*LElem_R
                             22*LElem_R  4*LElem_R^2  13*LElem_R  -3*LElem_R^2
                             54          13*LElem_R   156         -22*LElem_R
                             -13*LElem_R -3*LElem_R^2 -22*LElem_R 4*LElem_R^2];
%Mass matrix for 1 element of sleepers External
M1_S_Ext=((Arho_S*LElem_S_Ext)/420)*[156             22*LElem_S_Ext   54              -13*LElem_S_Ext
                                     22*LElem_S_Ext  4*LElem_S_Ext^2  13*LElem_S_Ext  -3*LElem_S_Ext^2
                                     54              13*LElem_S_Ext   156             -22*LElem_S_Ext
                                     -13*LElem_S_Ext -3*LElem_S_Ext^2 -22*LElem_S_Ext 4*LElem_S_Ext^2];
%Mass matrix for 1 element of sleepers Internal
M1_S_Int=((Arho_S*LElem_S_Int)/420)*[156             22*LElem_S_Int   54              -13*LElem_S_Int
                                     22*LElem_S_Int  4*LElem_S_Int^2  13*LElem_S_Int  -3*LElem_S_Int^2
                                     54              13*LElem_S_Ext   156             -22*LElem_S_Int
                                     -13*LElem_S_Int -3*LElem_S_Int^2 -22*LElem_S_Int 4*LElem_S_Int^2];
%
%Specifying nodes numbers
%
for i02=1:m_R %Railway
    elemNodes(i02,:)=[i02,i02+1];
end
for i03=0:num_S-1 %Sleepers
    for i04=(i03*numNodes_1S)+numNodes_R+1:(i03*numNodes_1S)+m_R+numNodes_1S 
    elemNodes(length(elemNodes)+1,:)=[i04,i04+1];
    end
end
for i05=1:num_S %Spring between Rail and Sleepers
    elemNodes(length(elemNodes)+1,:)=[(i05*numElem_R_betwSprings)+1,(i05*(m_1S+1))+numNodes_R-m_1S_Int];
end
for i06=1:numNodes_Stot %Spring between Sleepers and Ballast
    elemNodes(length(elemNodes)+1,:)=[i06+numNodes_R,i06+numNodes_R+numNodes_Stot];
end
%elemNodes   
for i07=1:numNodes-1
    indice=elemNodes(i07,:);
    elementDof=[2*(indice(1)-1)+1 2*(indice(2)-1)+1  %Vertical displacements
                2*(indice(1)-1)+2 2*(indice(2)-1)+2]; %Rotations
   if i07<=m_R
        stiffness(elementDof,elementDof)=stiffness(elementDof,elementDof)+K1_R;
        mass(elementDof,elementDof)=mass(elementDof,elementDof)+M1_R;
   else if i07<=m_R+m_Stot
           for i08=0:num_S-1
           for i09=(i08*m_1S)+1:(i08*m_1S)+m_1S_Ext
               if i07==m_R+i09
                   stiffness(elementDof,elementDof)=stiffness(elementDof,elementDof)+K1_S_Ext;
                   mass(elementDof,elementDof)=mass(elementDof,elementDof)+M1_S_Ext;
               end
           end
           for i10=(i08*m_1S)+1:(i08*m_1S)+m_1S_Int
               if i07==m_R+m_1S_Ext+i10
                   stiffness(elementDof,elementDof)=stiffness(elementDof,elementDof)+K1_S_Int;
                   mass(elementDof,elementDof)=mass(elementDof,elementDof)+M1_S_Int;
               end
           end
           end
    else if i07<=m_R+m_Stot+m_Spring_RS
               stiffness(elementDof,elementDof)=stiffness(elementDof,elementDof)+K1_Spring_RS;
    else
            stiffness(elementDof,elementDof)=stiffness(elementDof,elementDof)+K1_Spring_SB;
           end
       end
   end
end
force=[zeros(n*2-2,1);F1;zeros(GDof-4-(n*2-2),1)];
%boundary conditions
fixedNodeU=[1; GDof_R-1];%; zeros(numNodes_B,1)]
fixedNodeV=[2; GDof_R]; %; zeros(num_S+numNodes_B,1)]
for i11=GDof_R+GDof_1S:GDof_1S:GDof_R+GDof_Stot
    fixedNodeV(length(fixedNodeV)+1,1)=i11;
end
for i12=GDof_R+GDof_Stot+1:2:GDof-1
    fixedNodeU(length(fixedNodeU)+1,1)=i12;
    fixedNodeV(length(fixedNodeV)+1,1)=i12+1;
end
%Active degrees of fredoom
fixedDof=[fixedNodeU;fixedNodeV];
activeDof=setdiff([1:GDof]',[fixedDof]);
col_actDof=length(activeDof);

%STIFFNESS MATRIX REDUCED: considered only the active nodes
stiff_reduced=sparse(stiffness(activeDof,activeDof));

%MASS MATRIX REDUCED: considered only the active nodes
mass_reduced=sparse(mass(activeDof,activeDof));

%FORCE VECTOR REDUCED: considered only the active nodes
force_reduced=force;
force_reduced(fixedDof,:)=[];
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%SOLUTION: EIGENVALUE PROBLEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Eigenvectors(V) and Eigenvalues(D)
% [V,D]=eig(stiffness(activeDof(1:28),activeDof(1:28)),mass(activeDof(1:28),activeDof(1:28)));
[ E_Vec, eig_Values] = fem_4_dynEigs(stiff_reduced, mass_reduced, 10);
[V,D]=eig(stiffness(activeDof,activeDof),mass(activeDof,activeDof));
% omega=sqrt(diag(D));
Vtrasp_forceActDof=V'*force(activeDof);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%SOLUTION: DIRECT INTEGRATIONS USING NEWMARK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tic
% [L,D,P]=ldl(stiff_reduced);
% Y=(L*P)'*force_reduced;
% Z=D'*Y;
% U1=(P*L)*Z;
% 
% t1_end=toc
% 
% tic
% U2=force_reduced\stiff_reduced;
% t2_end=toc
%
%
%
for i13=1:col_actDof
    syms x(t)
    Dx=diff(x);
    x(t)=dsolve(diff(x,2)==Vtrasp_forceActDof(i13,1)-D(i13,i13)*x, x(0)==0,Dx(0)==0);
    x(t)=simplify(x);
    U(i13,1)=x(t);
end
U_t_V(t)=V*U;
for i14=1:t1
    t=t2*i14
    deltat(1,i14)=i14;
    U_t_funzt=U_t_V(t);
    U_fin=double(U_t_funzt);
    A_fin=inv(mass_reduced)*((-stiff_reduced*U_fin)+force_reduced);
    %Generation of the matrix for the displacement structure graph
    displac_nodes_R=[0;U_fin(1:2:GDof_R-4);0];
    for i15=0:num_S-1
        displac_nodes_S(i15*numNodes_1S+1:numNodes_1S+i15*numNodes_1S,1)=(U_fin(i15*(GDof_1S-1)+GDof_R-3:2:i15*(GDof_1S-1)+GDof_R+GDof_1S-5))';
    end
    total_displac_nodes_S=displac_nodes_S+(nodeCoord_S(:,2));
    matrix_displac_R(1:GDof_R/2,i14)=displac_nodes_R;
    matrix_displac_S(1:numNodes_Stot,i14)=total_displac_nodes_S;
    matrix_displac_B(1:numNodes_B,i14)=nodeCoord_B(:,2);
end
%DISPLACEMENT STRUCTURE GRAPH
SpringsRS_coord=zeros(2,m_Spring_RS);
for i16=1:m_Spring_RS
    SpringsRS_coord(:,i16)=nodeCoord_R(i16*numElem_R_betwSprings+1,1);
end
Link_RS=zeros(2,m_Spring_RS);
for i17=0:m_Spring_RS-1
    Link_RS(1,i17+1)=matrix_displac_R((i17+1)*numElem_R_betwSprings+1,1);
    Link_RS(2,i17+1)=matrix_displac_S(m_1S_Ext+1+(m_1S+1)*i17,1);  
end
SpringSB_coord=zeros(2,m_Spring_SB);
for i18=1:m_Spring_SB
    SpringSB_coord(:,i18)=nodeCoord_S(i18,1);
end
Link_SB=zeros(2,m_Spring_SB);
for i19=1:m_Spring_SB
    Link_SB(1,i19)=matrix_displac_S(i19,1);
    Link_SB(2,i19)=matrix_displac_B(i19,1);   
end
%
plot(nodeCoord_R(:,1),matrix_displac_R,'b--o')
hold on
plot(nodeCoord_S(:,1),matrix_displac_S,'ro')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
hold on
plot(nodeCoord_B(:,1),matrix_displac_B,'mo')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
hold on
plot(SpringsRS_coord,Link_RS,'k')
hold on
plot(SpringSB_coord,Link_SB,'m')
grid on
xlabel('nodeCoordinates [m]')
ylabel('Displacement structure [m]')
