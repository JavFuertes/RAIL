function [mat] = form_mat_trk(inp,geo)
GDof_R=geo.GDof(1);
GDof_1S=geo.GDof(2);
GDof_Stot=geo.GDof(3);
GDof=geo.GDof(5);
numNodes=geo.NumND(6);
m_R=geo.NumEL(1);
m_1S_Ext=geo.NumEL(2);
m_1S_Int=geo.NumEL(3);
m_1S=m_1S_Ext+m_1S_Int;
m_Stot=geo.NumEL(4);
m_Spring_RS=geo.NumEL(5);

%Initial vectors and matrices with zeros
stiffness=zeros(GDof,GDof);
mass=zeros(GDof,GDof);
damping=zeros(GDof,GDof);
%Force vector for 1 element
% % % F1=F.*[LElem_R*2 LElem_R^2*12 LElem_R*2 -LElem_R^2*12]';

%Element Mass and Stiffness matrix for rail
prompt='Please select the element type for rail(1.Euler;2.Timoshenko: [1]\n';
i=input(prompt);
if isempty(i)
    i=1;
end

switch i
    case 1
        
        
        [M1_R,K1_R]=euler_beam(inp.mater.E_R, inp.mater.I_R,inp.mater.A_R, inp.mater.rho_R, geo.LElem(1));
        
    case 2
        [M1_R,K1_R]=timoshenko_beam(inp.mater.E_R, inp.mater.I_R,inp.mater.A_R, ...
            inp.mater.G_R, inp.mater.kappa_R, inp.mater.rho_R, geo.LElem(1));
end
%Element Mass and Stiffness matrix for sleeper
prompt='Please select the element type for sleeper(1.Euler;2.Timoshenko: [1]\n';
i=input(prompt);
if isempty(i)
    i=1;
end

switch i
    case 1
        
        
        %Element Stiffness matrix of sleepers External
        
        [M1_S_Ext,K1_S_Ext]=euler_beam(inp.mater.E_S, inp.mater.I_S,inp.mater.A_S, inp.mater.rho_S, geo.LElem(2));
        
        %Element Stiffness matrix of sleepers Internal
        
        [M1_S_Int,K1_S_Int]=euler_beam(inp.mater.E_S, inp.mater.I_S,inp.mater.A_S, inp.mater.rho_S, geo.LElem(3));
    case 2
        %Element Stiffness matrix of sleepers External
        
        [M1_S_Ext,K1_S_Ext]=timoshenko_beam(inp.mater.E_S, inp.mater.I_S,inp.mater.A_S, inp.mater.G_S, inp.mater.kappa_S, inp.mater.rho_S, geo.LElem(2));
        
        %Element Stiffness matrix of sleepers Internal
        
       
        [M1_S_Int,K1_S_Int]=timoshenko_beam(inp.mater.E_S, inp.mater.I_S,inp.mater.A_S, inp.mater.G_S, inp.mater.kappa_S, inp.mater.rho_S, geo.LElem(3));
end

%Stiffness matrix for the spring between rail and sleepers

[K1_Spring_RS,C1_Damper_RS]=spring_element(inp.mater.K_Spring_RS,inp.mater.C_Damper_RS);


%Stiffness matrix for the spring between sleepers and ballast

[K1_Spring_SB, C1_Damper_SB]=spring_element(inp.mater.K_Spring_SB,inp.mater.C_Damper_SB);



for i07=1:numNodes-1
    indice=geo.EL(i07,2:3);
    elementDof=[2*(indice(1)-1)+1 2*(indice(2)-1)+1  %Vertical displacements
        2*(indice(1)-1)+2 2*(indice(2)-1)+2]; %Rotations
    if i07<=m_R
        stiffness(elementDof,elementDof)=stiffness(elementDof,elementDof)+K1_R;
        mass(elementDof,elementDof)=mass(elementDof,elementDof)+M1_R;
    else if i07<=m_R+m_Stot
            for i08=0:m_Spring_RS-1
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
                damping(elementDof,elementDof)=damping(elementDof,elementDof)+C1_Damper_RS;
            else
                stiffness(elementDof,elementDof)=stiffness(elementDof,elementDof)+K1_Spring_SB;
                damping(elementDof,elementDof)=damping(elementDof,elementDof)+C1_Damper_SB;
            end
        end
    end
end
% force=[zeros(n*2-2,1);F1;zeros(GDof-4-(n*2-2),1)];
%boundary conditions
fixedNodeU=[1; GDof_R-1];%; zeros(numNodes_B,1)]
fixedNodeV=[2; GDof_R]; %; zeros(num_S+numNodes_B,1)]
% for i11=GDof_R+GDof_1S:GDof_1S:GDof_R+GDof_Stot
%     fixedNodeV(length(fixedNodeV)+1,1)=i11;
% end
for i12=GDof_R+GDof_Stot+1:2:GDof-1
    fixedNodeU(length(fixedNodeU)+1,1)=i12;
    fixedNodeV(length(fixedNodeV)+1,1)=i12+1;
end
%Active degrees of fredoom
fixedDof=[fixedNodeU;fixedNodeV];
activeDof=setdiff([1:GDof]',[fixedDof]);
% col_actDof=length(activeDof);

%STIFFNESS MATRIX REDUCED: considered only the active nodes
mat.K_reduced=sparse(stiffness(activeDof,activeDof));

%MASS MATRIX REDUCED: considered only the active nodes
mat.M_reduced=sparse(mass(activeDof,activeDof));

mat.C_reduced=sparse(damping(activeDof,activeDof));
mat.fixedDof=fixedDof;
mat.activeDof=activeDof;

if length(stiffness) < 10000
    mat.K=sparse(stiffness);
    mat.M=sparse(mass);
    mat.C=sparse(damping);
end

%FORCE VECTOR REDUCED: considered only the active nodes
% force_reduced=force;
% force_reduced(fixedDof,:)=[];

end
