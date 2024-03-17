function [M, K]=euler_beam(E,I,A,rho,LElem)
EI=E*I;
Arho=A*rho;
%


%Stiffness matrix 
K=EI/(LElem)^3*[12        6*LElem    -12        6*LElem
                6*LElem   4*LElem^2  -6*LElem   2*LElem^2
                -12       -6*LElem   12         -6*LElem
                6*LElem   2*LElem^2  -6*LElem   4*LElem^2];
%Mass matrix 
M=((Arho*LElem)/420)*[156         22*LElem    54          -13*LElem
                      22*LElem    4*LElem^2   13*LElem    -3*LElem^2
                      54          13*LElem    156         -22*LElem
                      -13*LElem   -3*LElem^2  -22*LElem   4*LElem^2];


end