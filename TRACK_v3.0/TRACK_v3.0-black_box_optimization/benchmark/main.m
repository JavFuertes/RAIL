%%
%%%%%%input
clear;
L = 2;
E = 260e9;
A = 0.01;
kp = 5/6;
I = 1/120000;
nu = 0.3;
rho = 8000;
ngp = 10;
nel = 100;
%boundary conditions
fixedNodeU=[1,101];% vertical
fixedNodeV=[]; %; rotational
%%
%%%%% Mesh
node = [[1:nel+1]',linspace(0,L,nel+1)'];
elem = [[1:nel]', [1:nel]', [2:nel+1]'];

%%
%%%%% Form element matrix
[Ke,Me]=KMmatrixTiPoly(L/nel,E,A,kp,I,nu,rho,ngp);
% [Me, Ke]=timoshenko_beam(E,I,A,E/2/(1+nu),kp,rho,L/nel);


GDof=2*length(node);
K=zeros(GDof,GDof);
M=zeros(GDof,GDof);

for ii=1:nel
    indice=elem(ii,2:3);
    elementDof=[2*(indice(1)-1)+1 2*(indice(2)-1)+1  %Vertical displacements
    2*(indice(1)-1)+2 2*(indice(2)-1)+2]; %Rotations
    K(elementDof,elementDof)=K(elementDof,elementDof)+Ke;
    M(elementDof,elementDof)=M(elementDof,elementDof)+Me;
end



%Active degrees of fredoom
fixedDof=[2*(fixedNodeU-1)+1;2*(fixedNodeV-1)+2];
activeDof=setdiff((1:GDof)',fixedDof);
% col_actDof=length(activeDof);
%%
%STIFFNESS MATRIX REDUCED: considered only the active nodes
K_reduced=sparse(K(activeDof,activeDof));

%MASS MATRIX REDUCED: considered only the active nodes
M_reduced=sparse(M(activeDof,activeDof));

