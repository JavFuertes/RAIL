%form Hermite shape functions
function [shape,Ref_Dof,Ref_Node]=form_shape_fun(geo,mat_trk,coor)
shape=zeros(1,length(mat_trk.K_reduced));
x_coor=coor(1);
y_coor=coor(2);
z_coor=coor(3);
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
                Ref_Dof=[2*(i-1)-1, 2*(i-1),2*i-1,2*i];
                ind=ismember(mat_trk.activeDof,Ref_Dof); %get the index of Ref_Dof in activeDof
                H1=0.25*((1-xi)^2)*(2+xi);
                H2=LElem*(1/8)*((1-xi)^2)*(xi+1);
                H3=0.25*((1+xi)^2)*(2-xi);
                H4=LElem*(1/8)*((1+xi)^2)*(xi-1);
                
                shape(1,ind)=[H1,H2,H3,H4];
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





