function [N0, N1]=Nshape(xi, type, phi, L)
% All notations are in natural coordinates xi
% shape function and derivatives for L2 elements
% N0 : Shape functions 
%         First row: for vertical displacement
%         Second row: for rotational dof
% N1: derivatives w.r.t. xi
% xi: natural coordinates (-1 ... +1)
% type: different types of shape function
% ndof: number of degree of freedom per element
% phi: the ratio of the beam bending to shear stiffness
% L: element length
% Ref: [1] Eq. 5.63 in 1996 K. J. Bathe Finite Element Procedures
%      [2] Eq. 3.138 - 3.149 in B.S. Gan An Isogemetric Approach to beam structures (Polynimial shape functions)
%      [3] 
ndof = 4;
N0 = zeros (2, ndof); 
if type == 1 % linear shape function
	N0=([1-xi    0    1+xi    0
		    0    1-xi 0     1+xi]/2);
	N1=[-1  0  1  0
	     0 -1  0  1]/2;
elseif type == 2 % Polynomial (Exact?)
	N0(1,1) = 1/4/(1+phi)*(xi-1)*(xi^2+xi-2*(1+phi));
	N0(1,2) = L/8/(1+phi)*((xi^2-1)*(xi-1-phi));
	N0(1,3) = 1/4/(1+phi)*(2*(xi+1)*(1+phi)+xi-xi^3);
	N0(1,4) = L/8/(1+phi)*((xi^2-1)*(xi+1+phi));
	N0(2,1) = 3/2/L/(1+phi)*(xi^2-1);
	N0(2,2) = 1/4/(1+phi)*((xi-1)*(3*xi+1-2*phi));
	N0(2,3) = 3/2/L/(1+phi)*(-xi^2+1);
	N0(2,4) = 1/4/(1+phi)*((xi+1)*(3*xi-1+2*phi));
	N1(1,1) = 1/4/(1+phi)*(-3+3*xi^2-2*phi);
	N1(1,2) = L/8/(1+phi)*(-1+3*xi^2-2*xi*(1+phi));
	N1(1,3) = 1/4/(1+phi)*(3-3*xi^2+2*phi);
	N1(1,4) = L/8/(1+phi)*(-1+3*xi^2+2*xi*(1+phi));
	N1(2,1) = 3/L/(1+phi)*xi;
	N1(2,2) = 1/2/(1+phi)*(3*xi-1-phi);
	N1(2,3) = -3/L/(1+phi)*xi;
	N1(2,4) = 1/2/(1+phi)*(3*xi+1+phi);
elseif type == 3 % Hermite
	N0(1,1) = 0.25*((1-xi)^2)*(2+xi);
    N0(1,2)= L*(1/8)*((1-xi)^2)*(xi+1);
    N0(1,3)= 0.25*((1+xi)^2)*(2-xi);
    N0(1,4)= L*(1/8)*((1+xi)^2)*(xi-1);

end

end % end function shapeFunctionL2