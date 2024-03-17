function [Me,Ke,De,elementDof]=form_elem_mat(indice,elemType,elemLength, mater)
%reighley damping coefficient
alpha=0;
beta=0;
elementDof=[2*(indice(1)-1)+1 2*(indice(2)-1)+1  %Vertical displacements
    2*(indice(1)-1)+2 2*(indice(2)-1)+2]; %Rotations
switch elemType
    case 1%Euler beam
        [Me,Ke]=euler_beam(mater(1), mater(2),mater(3), mater(4), elemLength);
        De=alpha*Me+beta*Ke;
    case 2
        [Me,Ke]=timoshenko_beam(mater(1), mater(2),mater(3), mater(5),mater(6),mater(4), elemLength);
        De=alpha*Me+beta*Ke;
    case 3 %spring
        [Ke,De]=spring_element(mater(1),mater(2));
         Me=zeros(numel(elementDof),numel(elementDof));
    case 4 %spring mass 
        [Me,Ke,De]=spring_mass(mater(1), mater(2),mater(3), mater(4));
    case 5 %timo beam element with polynomial shape function and Gua integ
        nu=(mater(1)/mater(5)-2)/2;
        [Ke,Me]=KMmatrixTiPoly(elemLength,mater(1),mater(3),mater(6),mater(2),nu,mater(4),4);
        De=alpha*Me+beta*Ke;
end


end

function [M,K,C]=spring_mass(k,c,m1,m2)
K=k*[1  0 -1 0
     0  0 0  0
     -1 0 1  0
     0  0 0  0];
 C=c*[1  0 -1 0
     0  0 0  0
     -1 0 1  0
     0  0 0  0];
 M=[m1  0 0  0
     0  10e10 0  0
     0  0 m2 0
     0  0 0  10e10];
end

