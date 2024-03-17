% KMmatrixTiPoly.m
% Construct matrices K and M
% Based on the Timoshenko Beam Theory by using Polynomial functions
function [K,M]=KMmatrixTiPoly(L,E,A,kp,I,nu,rho,ngp)
% L = 1.3;
% E = 1525;
% A = 0.2;
% kp = 0.85;
% I = 0.014;
% nu = 0.3;
G = E/2/(1+nu);
phi = 12/L/L*E*I/kp/G/A;
% rho = 630;
% ngp = 4;
Gpw = Legendre(ngp);
Jac = L/2;
Kmtx = zeros(6,6);
Mmtx = zeros(6,6);
Nu1 = zeros(6,ngp);
Nv1 = zeros(6,ngp);
Nt1 = zeros(6,ngp);
Nu0 = zeros(6,ngp);
Nv0 = zeros(6,ngp);
Nt0 = zeros(6,ngp);
for i=1:ngp
t = Gpw(i,1);
NTiP = NshapeTiPoly(0,t,Jac,L,phi); % non derivative
Nu0(1:6,i)=NTiP(1:6,1);
Nv0(1:6,i)=NTiP(1:6,2);
Nt0(1:6,i)=NTiP(1:6,3);
NTiP = NshapeTiPoly(1,t,Jac,L,phi); % first derivative
Nu1(1:6,i)=NTiP(1:6,1);
Nv1(1:6,i)=NTiP(1:6,2);
Nt1(1:6,i)=NTiP(1:6,3);
end
for i=1:ngp
for j=1:6
for k=1:6
Kmtx(j,k) = Kmtx(j,k)+E*A*Nu1(j,i)*Nu1(k,i)*Jac*Gpw(i,2)...
+E*I*Nt1(j,i)*Nt1(k,i)*Jac*Gpw(i,2)+kp*G*A*(Nv1(j,i)-Nt0(j,i))...
*(Nv1(k,i)-Nt0(k,i))*Jac*Gpw(i,2);
end
end
end
% Swapping the matrices to the general displacement vector
Kmtx=Kmtx([1,3,5,2,4,6],:); % row
Kmtx=Kmtx(:,[1,3,5,2,4,6]); % column
% disp('The Stiffness Matrix');
% disp(Kmtx);
% Mass matrix K
for i=1:ngp
for j=1:6
for k=1:6
Mmtx(j,k) = Mmtx(j,k)+rho*A*Nu0(j,i)*Nu0(k,i)*Jac*Gpw(i,2)...
+ rho*A*Nv0(j,i)*Nv0(k,i)*Jac*Gpw(i,2)...
+ rho*I*Nt0(j,i)*Nt0(k,i)*Jac*Gpw(i,2);
end
end
end
% Swapping the matrices to the general displacement vector
Mmtx=Mmtx([1,3,5,2,4,6],:); % row
Mmtx=Mmtx(:,[1,3,5,2,4,6]); % column
% disp('The Mass Matrix');
% disp(Mmtx);

index=[zeros(1,6);
       0,1,1,0,1,1;
       0,1,1,0,1,1];
   index=logical([index;index]);
   K=reshape(Kmtx(index),[4,4]);
   M=reshape(Mmtx(index),[4,4]);
   
end

function NTiP = NshapeTiPoly(i,t,Jac,L,phi)
% i = 0~p derivative Shape Function, 0 not derived
% xi = Gauss coordinate
% L = beam length
%-----------------------------------
NTiP=zeros(6,3); % (DOF(6), 0-1 derivatives)
switch i
case 0
NTiP(1,1) = (1-t)/2;
NTiP(2,1) = (1+t)/2;
NTiP(3,1) = 0; NTiP(4,1) = 0; NTiP(5,1) = 0; NTiP(6,1) = 0;
NTiP(1,2) = 0; NTiP(2,2) = 0;
NTiP(3,2) = 1/4/(1+phi)*(t-1)*(t^2+t-2*(1+phi));
NTiP(4,2) = 1/4/(1+phi)*(2*(t+1)*(1+phi)+t-t^3);
NTiP(5,2) = L/8/(1+phi)*((t^2-1)*(t-1-phi));
NTiP(6,2) = L/8/(1+phi)*((t^2-1)*(t+1+phi));
NTiP(1,3) = 0; NTiP(2,3) = 0;
NTiP(3,3) = 3/2/L/(1+phi)*(t^2-1);
NTiP(4,3) = 3/2/L/(1+phi)*(-t^2+1);
NTiP(5,3) = 1/4/(1+phi)*((t-1)*(3*t+1-2*phi));
NTiP(6,3) = 1/4/(1+phi)*((t+1)*(3*t-1+2*phi));
case 1
NTiP(1,1) = (-1)/2/Jac;
NTiP(2,1) = (1)/2/Jac;
NTiP(3,1) = 0; NTiP(4,1) = 0; NTiP(5,1) = 0; NTiP(6,1) = 0;
NTiP(1,2) = 0; NTiP(2,2) = 0;
NTiP(3,2) = 1/4/(1+phi)*(-3+3*t^2-2*phi)/Jac;
NTiP(4,2) = 1/4/(1+phi)*(3-3*t^2+2*phi)/Jac;
NTiP(5,2) = L/8/(1+phi)*(-1+3*t^2-2*t*(1+phi))/Jac;
NTiP(6,2) = L/8/(1+phi)*(-1+3*t^2+2*t*(1+phi))/Jac;
NTiP(1,3) = 0; NTiP(2,3) = 0;
NTiP(3,3) = 3/L/(1+phi)*t/Jac;
NTiP(4,3) = -3/L/(1+phi)*t/Jac;
NTiP(5,3) = 1/2/(1+phi)*(3*t-1-phi)/Jac;
NTiP(6,3) = 1/2/(1+phi)*(3*t+1+phi)/Jac;
end
end

function Gpw = Legendre(ng)
% ng = number of Gauss points
% Gauss point is stored in Gpw(n,1)
% Gauss weight is stored in Gpw(n,2)
%-----------------------------------
Gpw=zeros(ng,2);
switch ng
case 1
Gpw(1,1)=0;
Gpw(1,2)=2;
case 2
Gpw(1,1)=-sqrt(1/3);
Gpw(1,2)=1;
Gpw(2,1)=+sqrt(1/3);
Gpw(2,2)=1;
case 3
Gpw(1,1)=-sqrt(3/5);
Gpw(1,2)=5/9;
Gpw(2,1)=0;
Gpw(2,2)=8/9;
Gpw(3,1)=+sqrt(3/5);
Gpw(3,2)=5/9;
case 4
Gpw(1,1)=-sqrt(3/7+2/7*sqrt(6/5));
Gpw(1,2)=(18-sqrt(30))/36;
Gpw(2,1)=-sqrt(3/7-2/7*sqrt(6/5));
Gpw(2,2)=(18+sqrt(30))/36;
Gpw(3,1)=+sqrt(3/7-2/7*sqrt(6/5));
Gpw(3,2)=(18+sqrt(30))/36;
Gpw(4,1)=+sqrt(3/7+2/7*sqrt(6/5));
Gpw(4,2)=(18-sqrt(30))/36;
case 5
Gpw(1,1)=-1/3*sqrt(5+2*sqrt(10/7));
Gpw(1,2)=(322-13*sqrt(70))/900;
Gpw(2,1)=-1/3*sqrt(5-2*sqrt(10/7));
Gpw(2,2)=(322+13*sqrt(70))/900;
Gpw(3,1)=0;
Gpw(3,2)=128/225;
Gpw(4,1)=+1/3*sqrt(5-2*sqrt(10/7));
Gpw(4,2)=(322+13*sqrt(70))/900;
Gpw(5,1)=+1/3*sqrt(5+2*sqrt(10/7));
Gpw(5,2)=(322-13*sqrt(70))/900;
case 6
Gpw(1,1) = -0.932469514203151938982;
Gpw(2,1) = -0.661209386466264592509;
Gpw(3,1) = -0.238619186083196932469;
Gpw(4,1) = 0.238619186083196932469;
Gpw(5,1) = 0.661209386466264592509;
Gpw(6,1) = 0.932469514203151938982;
Gpw(1,2) = 0.171324492379171867455;
Gpw(2,2) = 0.360761573048138139704;
Gpw(3,2) = 0.467913934572691007877;
Gpw(4,2) = 0.467913934572691007877;
Gpw(5,2) = 0.360761573048138139704;
Gpw(6,2) = 0.171324492379171867455;
case 7
Gpw(1,1) = -0.949107912342758486214;
Gpw(2,1) = -0.741531185599394682074;
Gpw(3,1) = -0.405845151377397184156;
Gpw(4,1) = 0.000000000000000000000;
Gpw(5,1) = 0.405845151377397184156;
Gpw(6,1) = 0.741531185599394682074;
Gpw(7,1) = 0.949107912342758486214;
Gpw(1,2) = 0.129484966168870452732;
Gpw(2,2) = 0.279705391489274882221;
Gpw(3,2) = 0.381830050505118893749;
Gpw(4,2) = 0.417959183673469387755;
Gpw(5,2) = 0.381830050505118893749;
Gpw(6,2) = 0.279705391489274882221;
Gpw(7,2) = 0.129484966168870452732;
case 8
Gpw(1,1) = -0.960289856497536509162;
Gpw(2,1) = -0.796666477413626949956;
Gpw(3,1) = -0.525532409916328990763;
Gpw(4,1) = -0.183434642495649807836;
Gpw(5,1) = 0.183434642495649807836;
Gpw(6,1) = 0.525532409916328990763;
Gpw(7,1) = 0.796666477413626949956;
Gpw(8,1) = 0.960289856497536509162;
Gpw(1,2) = 0.101228536290370022005;
Gpw(2,2) = 0.222381034453372634246;
Gpw(3,2) = 0.313706645877887267061;
Gpw(4,2) = 0.362683783378361979375;
Gpw(5,2) = 0.362683783378361979375;
Gpw(6,2) = 0.313706645877887267061;
Gpw(7,2) = 0.222381034453372634246;
Gpw(8,2) = 0.101228536290370022005;
case 9
Gpw(1,1) = -0.968160239507625086598;
Gpw(2,1) = -0.836031107326636102552;
Gpw(3,1) = -0.613371432700592578104;
Gpw(4,1) = -0.324253423403808971326;
Gpw(5,1) = 0.000000000000000000000;
Gpw(6,1) = 0.324253423403808971326;
Gpw(7,1) = 0.613371432700592578104;
Gpw(8,1) = 0.836031107326636102552;
Gpw(9,1) = 0.968160239507625086598;
Gpw(1,2) = 0.081274388361599606396;
Gpw(2,2) = 0.180648160694854311268;
Gpw(3,2) = 0.260610696402924285138;
Gpw(4,2) = 0.312347077040002744348;
Gpw(5,2) = 0.330239355001259763165;
Gpw(6,2) = 0.312347077040002744348;
Gpw(7,2) = 0.260610696402924285138;
Gpw(8,2) = 0.180648160694854311268;
Gpw(9,2) = 0.081274388361599606396;
case 10
Gpw(1,1) = -0.973906528517169189864;
Gpw(2,1) = -0.865063366688986756738;
Gpw(3,1) = -0.679409568299023991446;
Gpw(4,1) = -0.433395394129247379933;
Gpw(5,1) = -0.148874338981631215706;
Gpw(6,1) = 0.148874338981631215706;
Gpw(7,1) = 0.433395394129247379933;
Gpw(8,1) = 0.679409568299023991446;
Gpw(9,1) = 0.865063366688986756738;
Gpw(10,1)= 0.973906528517169189864;
Gpw(1,2) = 0.066671344308758311881;
Gpw(2,2) = 0.149451349150555209279;
Gpw(3,2) = 0.219086362515984566833;
Gpw(4,2) = 0.269266719309995757214;
Gpw(5,2) = 0.295524224714752865402;
Gpw(6,2) = 0.295524224714752865402;
Gpw(7,2) = 0.269266719309995757214;
Gpw(8,2) = 0.219086362515984566833;
Gpw(9,2) = 0.149451349150555209279;
Gpw(10,2) = 0.066671344308758311881;
end
end
