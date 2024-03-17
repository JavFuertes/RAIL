function [geo_deformed]=plot_modeShape(geo,shape,scale)
geo_deformed=geo;
% index=ismember(geo.ND(:,1),geo.fixedNodeU);
% index=~index;
% geo_deformed.ND=geo.ND(index,:);
geo_deformed.ND(:,4)=geo_deformed.ND(:,4)+shape*scale;
% geo_deformed.ND=[geo_deformed.ND;geo.ND(~index,:)];
% geo_deformed.ND=sortrows(geo_deformed.ND);

plot_geo(geo_deformed);
end