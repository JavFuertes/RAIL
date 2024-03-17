function []=plot_geo(geo,railOnly)
% figure;
hold on
if nargin < 2
    railOnly = 0;
end
% %plot element
for i=1:length(geo.EL)
    node1=geo.EL(i,2);
    node2=geo.EL(i,3);
    nodeInd1 = geo.ND(:,1)== node1;
    nodeInd2 = geo.ND(:,1)== node2;
    x1=[geo.ND(nodeInd1,2);geo.ND(nodeInd2,2)];
    y1=[geo.ND(nodeInd1,3);geo.ND(nodeInd2,3)];
    z1=[geo.ND(nodeInd1,4);geo.ND(nodeInd2,4)];
    %     plot3(x1,y1,z1)
    %     hold on
    if geo.EL(i,4) < 3
        if railOnly == 1
            if geo.EL(i,4) == 1
            plot3(x1,y1,z1,'Color','blue','LineWidth',2);
            elseif geo.EL(i,4) == 2
            plot3(x1,y1,z1,'Color','red','LineWidth',2);
            end
        else
            if geo.EL(i,4) == 1
            plot3(x1,y1,z1,'Color','blue','Marker','o');
            elseif geo.EL(i,4) == 2
            plot3(x1,y1,z1,'Color','red','Marker','o');
            end
            
        end
    elseif geo.EL(i,4)==3
        if railOnly == 1
            
        else
            plot3(x1,y1,z1+0.2,'Color','k','LineWidth',2);
        end
    else
        %plot3(x1,y1,z1,'Color','cyan');
    end
    
end
% %plot boundary conditions
% x2=geo.ND(geo.fixedNodeU,2);
% y2=geo.ND(geo.fixedNodeU,3);
% z2=geo.ND(geo.fixedNodeU,4);
% scatter3(x2,y2,z2,36,'m','^');
%
%
% x3=geo.ND(geo.fixedNodeV,2);
% y3=geo.ND(geo.fixedNodeV,3);
% z3=geo.ND(geo.fixedNodeV,4);
% scatter3(x3,y3,z3,36,'g','>');
hold off

view(45,45.45)
xlim([14.3,16.9]);
zlim([-0.4,0.3]);
end
