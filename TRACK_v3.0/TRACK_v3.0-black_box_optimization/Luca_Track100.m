%
clear
clc
format short
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT DATA 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE STUDY DATA
Ltot_R=60;                 %[m] Length of the rail
dist_S=0.6;               %[m] Distance between sleepers 
dist_R_betwSprings=dist_S; %[m] Distance betweeen Springs
numElem_R_betwSprings=10;   %Number of elements between 2 springs
m_1S_Ext=1;                 %Number of elements in a sleeper external
m_1S_Int=3;                %Number of elements in a sleeper internal
LExt_S=0.430;              %[m] Length of the sleeper external
LInt_S=0.750;              %[m] Length of the sleeper internal
Ltot_S=1.18;               %[m] Length of the sleeper (to consider the symmetry)
dist_RS=0.2;               %[m] Distance between rail and sleepers
dist_SB=0.2;               %[m] Distance between sleepers and ballast
%F=[-150e3 0 0 0]';         %[N] Load on the rail
%n=3                        %Node's number in which there's the F(1,1)
timeh=('example.txt')
load_timeh=load(timeh)
%sf=length(load_timeh)
sf=25600
deltat=1/sf
x_coord=30;
%t1=5;                       %Number of time calculations
%t2=0.001;                   %[s] Time steps
%MATERIAL RAIL DATA 
E_R=210e9;     %[N/m^2]
I_R=3.0383e-5; %[m^4]
A_R=7.62e-3;   %[m^2]
rho_R=7800;    %[kg/m^3]
%MATERIAL SLEEPERS DATA 
E_S=64e9;     %[N/m^2]
I_S=1.75e-4;  %[m^4]
A_S=5.138e-2; %[m^2]
rho_S=3070;   %[kg/m^3]
%MATERIAL SPRING DATA 
K_Spring_RS=150e6; %[N/m]
K_Spring_SB=40e6;  %[N/m]
%DAMPING RAIL AND SLEEPERS DATA
omega_ref=1000; %Omega reference, random value
damping1=0.03;  %Random value
damping2=0.04;  %Random value
%DAMPERS
%C_Damper_RS=50e3;   %[(N*s)/m^2]
%C_Damper_SB=25.4e3; %[(N*s)/m^2]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SOLUTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Geometric parameters
EI_R=E_R*I_R;
Arho_R=A_R*rho_R;
EI_S=E_S*I_S;
Arho_S=A_S*rho_S;
m_Spring_RS=(Ltot_R/dist_R_betwSprings)-1;
num_S=m_Spring_RS;
LElem_R=Ltot_R/((numElem_R_betwSprings)*(m_Spring_RS+1));
m_R=Ltot_R/LElem_R;
m_1S=m_1S_Ext+m_1S_Int;
m_Stot=m_1S*num_S;
LElem_S_Ext=LExt_S/m_1S_Ext;
LElem_S_Int=LInt_S/m_1S_Int;
numNodes_R=m_R+1;
numNodes_1S_Ext=m_1S_Ext+1;
numNodes_1S_Int=m_1S_Int+1;
numNodes_1S=m_1S+1;
numNodes_Stot=m_Stot+num_S;
numNodes_B=numNodes_Stot;
numNodes=numNodes_R+numNodes_Stot+numNodes_B;
m_Spring_SB=numNodes_B;
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
nodeCoord_RSB=[nodeCoord_R;nodeCoord_S;nodeCoord_B]; %[x,y]
nodeCoord=[1:length(nodeCoord_RSB);nodeCoord_RSB']'; %[numNodes,x,y
GDof_R=2*numNodes_R;
GDof_1S=2*numNodes_1S;
GDof_Stot=2*numNodes_Stot;
GDof_B=2*numNodes_B;
GDof=GDof_R+GDof_Stot+GDof_B;
%Initial vectors and matrices with zeros
stiffness=zeros(GDof,GDof);
mass=zeros(GDof,GDof);
%Force vector for 1 element
%F1=F.*[LElem_R*2 LElem_R^2*12 LElem_R*2 -LElem_R^2*12]';
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
%Mass matrix for 1 element of sleeper External
M1_S_Ext=((Arho_S*LElem_S_Ext)/420)*[156             22*LElem_S_Ext   54              -13*LElem_S_Ext
                                     22*LElem_S_Ext  4*LElem_S_Ext^2  13*LElem_S_Ext  -3*LElem_S_Ext^2
                                     54              13*LElem_S_Ext   156             -22*LElem_S_Ext
                                     -13*LElem_S_Ext -3*LElem_S_Ext^2 -22*LElem_S_Ext 4*LElem_S_Ext^2];
%Mass matrix for 1 element of sleeper Internal
M1_S_Int=((Arho_S*LElem_S_Int)/420)*[156             22*LElem_S_Int   54              -13*LElem_S_Int
                                     22*LElem_S_Int  4*LElem_S_Int^2  13*LElem_S_Int  -3*LElem_S_Int^2
                                     54              13*LElem_S_Ext   156             -22*LElem_S_Int
                                     -13*LElem_S_Int -3*LElem_S_Int^2 -22*LElem_S_Int 4*LElem_S_Int^2]; 
%Damping matrix for the damper between rail and sleepers
%C1_Damper_RS=C_Damper_RS*[1  0 -1 0
                          %0  0 0  0
                          %-1 0 1  0
                          %0  0 0  0];
%Damping matrix for the damper between sleepers and ballast
%C1_Damper_SB=C_Damper_SB*[1  0 -1 0
                          %0  0 0  0
                          %-1 0 1  0
                          %0  0 0  0];
%Nodes for each element                                 
for i02=1:m_R %Railway
    elemNodes(i02,:)=[i02,i02+1];
end
for i03=0:num_S-1 %Sleepers
    for i04=(i03*numNodes_1S)+numNodes_R+1:(i03*numNodes_1S)+m_R+numNodes_1S 
    elemNodes(length(elemNodes)+1,:)=[i04,i04+1];
    end
end
for i05=1:num_S %Spring between rail and sleepers
    elemNodes(length(elemNodes)+1,:)=[(i05*numElem_R_betwSprings)+1,(i05*(m_1S+1))+numNodes_R-m_1S_Int];
end
for i06=1:numNodes_Stot %Spring between sleepers and ballast
    elemNodes(length(elemNodes)+1,:)=[i06+numNodes_R,i06+numNodes_R+numNodes_Stot];
end
%Creation of the stiffness and mass matrices
for i07=1:numNodes-1
    indice=elemNodes(i07,:);
    elemDof=[2*(indice(1)-1)+1 2*(indice(2)-1)+1   %Vertical displacements
             2*(indice(1)-1)+2 2*(indice(2)-1)+2]; %Rotations
   if i07<=m_R
        stiffness(elemDof,elemDof)=stiffness(elemDof,elemDof)+K1_R;
        mass(elemDof,elemDof)=mass(elemDof,elemDof)+M1_R;
   else if i07<=m_R+m_Stot
           for i08=0:num_S-1
           for i09=(i08*m_1S)+1:(i08*m_1S)+m_1S_Ext
               if i07==m_R+i09
                   stiffness(elemDof,elemDof)=stiffness(elemDof,elemDof)+K1_S_Ext;
                   mass(elemDof,elemDof)=mass(elemDof,elemDof)+M1_S_Ext;
               end
           end
           for i10=(i08*m_1S)+1:(i08*m_1S)+m_1S_Int
               if i07==m_R+m_1S_Ext+i10
                   stiffness(elemDof,elemDof)=stiffness(elemDof,elemDof)+K1_S_Int;
                   mass(elemDof,elemDof)=mass(elemDof,elemDof)+M1_S_Int;
               end
           end
           end
       else if i07<=m_R+m_Stot+m_Spring_RS
               stiffness(elemDof,elemDof)=stiffness(elemDof,elemDof)+K1_Spring_RS;
           else stiffness(elemDof,elemDof)=stiffness(elemDof,elemDof)+K1_Spring_SB;
           end
       end
   end
end
%Creation of the force vector
%force=[zeros(n*2-2,1);F1;zeros(GDof-4-(n*2-2),1)];
%Boundary conditions (clamped ends rail, clamped ballast, rotation of sleepers in the interface of symmetry)
fixedNodeU=[1; GDof_R-1];
fixedNodeV=[2; GDof_R];
for i11=GDof_R+GDof_1S:GDof_1S:GDof_R+GDof_Stot
    fixedNodeV(length(fixedNodeV)+1,1)=i11;
end
for i12=GDof_R+GDof_Stot+1:2:GDof-1
    fixedNodeU(length(fixedNodeU)+1,1)=i12;
    fixedNodeV(length(fixedNodeV)+1,1)=i12+1;
end
%Active degrees of fredoom
fixedDof=[fixedNodeU;fixedNodeV];
activeDof=setdiff(1:GDof,fixedDof);
dof=length(activeDof);
%Eigenvectors(V) and Eigenvalues(D)
%[V,D]=eig(stiffness(activeDof,activeDof),mass(activeDof,activeDof));
%omega=sqrt(diag(D));
%Damping evaluation for rail and sleepers
%zita=zeros(col_actDof,1);
%for i13=1:col_actDof
    %if omega(i13,1)<=omega_ref
       %zita(i13,1)=zita(i13,1)+damping1;
    %else
        %zita(i13,1)=zita(i13,1)+damping2;
    %end
%end
%x=ceil(col_actDof/2);
%omega_average1=mean(omega([1,x],1));
%omega_average2=mean(omega([x+1,end],1));
%zita_average1=mean(zita([1,x],1));
%zita_average2=mean(zita([x+1,end],1));
%syms Alfa Beta e1 e2
%e1=Alfa+Beta*omega_average1^2-2*omega_average1*zita_average1;
%e2=Alfa+Beta*omega_average2^2-2*omega_average2*zita_average2;
%sol=solve(e1,e2,Alfa,Beta);
%sol.Alfa;
%alfa=double(ans);
%sol.Beta;
%beta=double(ans);
%damping=alfa.*mass+beta.*stiffness;
%Creation of the damping matrix with the dampers 
%for i14=1:numNodes-1
    %indice=elemNodes(i14,:);
    %elemDof=[2*(indice(1)-1)+1 2*(indice(2)-1)+1   %Vertical displacements
             %2*(indice(1)-1)+2 2*(indice(2)-1)+2]; %Rotations
    %if i14<=m_R+m_Stot
    %else if i14<=m_R+m_Stot+m_Spring_RS
            %damping(elemDof,elemDof)=damping(elemDof,elemDof)+C1_Damper_RS;
        %else damping(elemDof,elemDof)=damping(elemDof,elemDof)+C1_Damper_SB;
        %end
    %end
%end
%Stiffness matrix reduced: considered only the active nodes
stiff_reduced=stiffness;
stiff_reduced(fixedDof,:)=[];
stiff_reduced(:,fixedDof)=[];
%Mass matrix reduced: considered only the active nodes
mass_reduced=mass;
mass_reduced(fixedDof,:)=[];
mass_reduced(:,fixedDof)=[];
%Force vector reduced: considered only the active nodes
%force_reduced=force;
%force_reduced(fixedDof,:)=[]
%Damping matrix reduced: considered only the active nodes
%damp_reduced=damping;
%damp_reduced(fixedDof,:)=[];
%damp_reduced(:,fixedDof)=[];

shape=zeros(1,dof);
%search for the element
for e1=1:numNodes_R
    if x_coord <= nodeCoord(e1,2)
        herm_zita=1-(nodeCoord(e1,2)-x_coord)/(nodeCoord(e1)-nodeCoord(e1-1))*2;
        herm_N1=0.25*((1-herm_zita)^2)*(2+herm_zita);
        herm_M1=LElem_R*(1/8)*((1-herm_zita)^2)*(herm_zita+1);
        herm_N2=0.25*((1+herm_zita)^2)*(2-herm_zita);
        herm_M2=LElem_R*(1/8)*((1+herm_zita)^2)*(herm_zita-1);
        Ref_Dof=[2*(e1-1)-1, 2*(e1-1),2*e1-1,2*e1];
        shape(1,Ref_Dof)=[herm_N1,herm_M1,herm_N2,herm_M2];
        %shape=sparse(shape);
        break
    elseif e1==numNodes_R
        display(['Error: Wheel or load position are out of range. x_coord must be between ', num2str(nodeCoord(1,2)),' and ', num2str(nodeCoord(e1,2))]);
    end
end

%Solution with Newmark's method

%Initial conditions
Ut=zeros(sf-1,dof);
Vt=zeros(sf-1,dof);
At=zeros(sf-1,dof);
% %initial conditions
% Ut(1,:)=initial.dis;
% Vt(1.:)=initial.vel;
% At(1,:)=initial.acc;

delta=0.5;
alfa=0.25*(0.5+delta)^2;
a0=1/(alfa*deltat^2);
a1=delta/(alfa*deltat);
a2=1/(alfa*deltat);
a3=(1/(2*alfa))-1;
a4=(delta/alfa)-1;
a5=(deltat/2)*((delta/alfa)-2);
a6=deltat*(1-delta);
a7=delta*deltat;

disp (['Starting Newmark intergration. Time: ' datestr(datetime('now'))]);
tic;
for i15=1:sf-1
    %deltaT(1,i15)=i15
    force=load_timeh(i15+1)*shape';
    R=force+mass_reduced*(a0*Ut(i15,:)'+a2*Vt(i15,:)'+a3*At(i15,:)');%+damp_reduced*(a1*Ut+a4*Vt+a5*At);
    K=stiff_reduced+a0*mass_reduced;%+a1*damp_reduced;
    Ut(i15+1,:)=(K\R)'; %the same of inv(K)*R
    At(i15+1,:)=a0*(Ut(i15+1,:)-Ut(i15,:))-a2*Vt(i15,:)-a3*At(i15,:);
    Vt(i15+1,:)=Vt(i15,:)+a6*At(i15,:)+a7*At(i15+1,:);
    %Ut=Ut1
    %Vt=Vt1
    %At=At1
    %Generation of the matrix for the displacement structure graph
    %displac_nodes_R=[0;Ut(1:2:GDof_R-4);0];
    %for i16=0:num_S-1
        %displac_nodes_S(i16*numNodes_1S+1:numNodes_1S+i16*numNodes_1S,1)=(Ut(i16*(GDof_1S-1)+GDof_R-3:2:i16*(GDof_1S-1)+GDof_R+GDof_1S-5))';
    %end
    %total_displac_nodes_S=displac_nodes_S+(nodeCoord_S(:,2));
    %matrix_displac_R(1:GDof_R/2,i15)=displac_nodes_R;
    %matrix_displac_S(1:numNodes_Stot,i15)=total_displac_nodes_S;
    %matrix_displac_B(1:numNodes_B,i15)=nodeCoord_B(:,2);
    disp (['Time step: ' num2str(i15) 'finished. Time' num2str(toc)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GRAPHS

%%%Author: Chen Shen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%build track model

t=(0:sf-1)*deltat;

X_load=x_coord;

Ut_x_load=Ut*shape';
figure;
plot(t,Ut_x_load);

[p_dis,f_dis]=periodogram(Ut_x_load(2:length(Ut_x_load)),hamming(length(Ut_x_load)-1),length(Ut_x_load),sf);
force1=load(timeh);
[p_force,f_force]=periodogram(force1,hamming(length(force1)),length(force1)-1,sf);

figure;
plot(f_dis,p_dis./p_force);

Ut=Ut(:,Ref_Dof);
At=At(:,Ref_Dof);
Vt=Vt(:,Ref_Dof);
% clear force geo mat_trk ;


