function []=plot_geo(geo)
% figure;
hold on
%plot element
for i=1:length(geo.EL)
    node1=geo.EL(i,2);
    node2=geo.EL(i,3);
    x1=[geo.ND(node1,2);geo.ND(node2,2)];
    y1=[geo.ND(node1,3);geo.ND(node2,3)];
    z1=[geo.ND(node1,4);geo.ND(node2,4)];
%     plot3(x1,y1,z1)
%     hold on
    if geo.EL(i,4) < 3
        plot3(x1,y1,z1,'Color','blue','Marker','o','MarkerSize',2);  
    elseif geo.EL(i,4)==3
        plot3(x1,y1,z1,'Color','k','LineWidth',2,'Marker','o');
    else
        plot3(x1,y1,z1,'Color','cyan');
    end
  
end
%plot boundary conditions
x2=geo.ND(geo.fixedNodeU,2);
y2=geo.ND(geo.fixedNodeU,3);
z2=geo.ND(geo.fixedNodeU,4);
scatter3(x2,y2,z2,36,'m','^');


x3=geo.ND(geo.fixedNodeV,2);
y3=geo.ND(geo.fixedNodeV,3);
z3=geo.ND(geo.fixedNodeV,4);
scatter3(x3,y3,z3,36,'g','>');
hold off

view(45,45.45)
xlim([14.3,16.9]);
zlim([-0.5,0.1]);
end
