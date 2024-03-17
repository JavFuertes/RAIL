function [M, K]=timoshenko_beam(E,I,A,G,kappa,rho,LElem)
EI=E*I;
Arho=A*rho;

phi=12*EI/(kappa*A*G*LElem^2);
phi1=1+phi;
phi2=4+phi;
phi3=2-phi;
phim1=312+588*phi+280*phi^2;
phim2=44+77*phi+35*phi^2;
phim3=108+252*phi+175*phi^2;
phim4=-26-63*phi-35*phi^2;
phim5=8+14*phi+7*phi^2;
phim6=-1*phim4;
phim7=-6-14*phi-7*phi^2;
phim8=phim1;
phim9=-1*phim2;
phim10=phim5;



%Stiffness matrix 
K=EI/(phi1*(LElem)^3)*[12         6*LElem       -12        6*LElem
                        6*LElem   phi2*LElem^2  -6*LElem   phi3*LElem^2
                        -12       -6*LElem      12         -6*LElem
                       6*LElem    phi3*LElem^2  -6*LElem   phi2*LElem^2];
%Mass matrix 
Mt=((Arho*LElem)/(840*phi1^2))...
    *[phim1          phim2*LElem     phim3          phim4*LElem
      phim2*LElem    phim5*LElem^2   phim6*LElem    phim7*LElem^2
      phim3          phim6*LElem     phim8          phim9*LElem
      phim4*LElem    phim7*LElem^2   phim9*LElem     phim10*LElem^2];
Mr=((rho*I)/(30*phi1^2)*LElem)...
    *[36                 -(15*phi-3)*LElem           -36                 -(15*phi-3)*LElem
    -(15*phi-3)*LElem   (10*phi^2+5*phi+4)*LElem^2  (15*phi-3)*LElem    (5*phi^2-5*phi-1)*LElem^2
    -36                 (15*phi-3)*LElem             36                  (15*phi-3)*LElem
    -(15*phi-3)*LElem   (5*phi^2-5*phi-1)*LElem^2    (15*phi-3)*LElem    (10*phi^2+5*phi+4)*LElem^2];
M=Mt+Mr;

% M=((Arho*LElem)/420)*[156         22*LElem    54          -13*LElem
%                       22*LElem    4*LElem^2   13*LElem    -3*LElem^2
%                       54          13*LElem    156         -22*LElem
%                       -13*LElem   -3*LElem^2  -22*LElem   4*LElem^2];


end