%form the shape function for timoshenko beam element
function [shape,Ref_Dof,Ref_Node]=form_shape_fun2(geo,mat_trk,coor,mater)
shape=zeros(1,length(mat_trk.K_reduced));
x_coor=coor(1);
y_coor=coor(2);
z_coor=coor(3);
E = mater(1);
I = mater(2);
A = mater(3);
G = mater(5);
kappa = mater(6);
rho = (4);

EI=E*I;

switch z_coor
    case 0.00
        if y_coor<0
            startNode=1;
            endNode=length(find(~(geo.ND(:,5)-1)));
            %search for the element
        else
            startNode=length(find(~(geo.ND(:,5)-1)))+1;
            endNode=length(find(~(geo.ND(:,5)-1)))+length(find(~(geo.ND(:,5)-2)));
        end
        
        for i=startNode:endNode
            if x_coor <= geo.ND(i,2)
                %i
                LElem=node_distance(geo.ND(i-1,1),geo.ND(i,1),geo.ND);
                xi=1-(geo.ND(i,2)-x_coor)/(geo.ND(i,2)-geo.ND(i-1,2))* 2;
                phi=12*EI/(kappa*A*G*LElem^2);
                Ref_Dof=[2*(i-1)-1, 2*(i-1),2*i-1,2*i];
                ind=ismember(mat_trk.activeDof,Ref_Dof); %get the index of Ref_Dof in activeDof
                
                
                N0=Nshape(xi, 2, phi, LElem);

                shape(1,ind)=N0(1,:);
                shape=sparse(shape);
                Ref_Node=[i-1,i];
                break
            elseif i==endNode+1
                
                display('Erro: Wheel or load position out of range.' ); % X_coor should be between ', num2str(geo.ND(1,2)),' and ', num2str(geo.ND(i,2))]);
                
            end
            
        end
    case -0.2
        display('We are sorry but we are not ready ');
    otherwise
        display('Input coordinates are not on any elements ');
end


end





