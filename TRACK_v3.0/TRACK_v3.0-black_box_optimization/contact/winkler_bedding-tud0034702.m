%%2D contact model in longitudinal/rolling direction
%  computes the normal contact force using winkler bedding methods
%  See Ford and Thompson, 2006 for detail
%INPUT
%  
%%
function [Fn,f]=winkler_bedding(X_w0, X_w, ver_dis_r,ver_dis_w,ver_irr, geo, mat_trk,inp,railID,  dx,a)

a=1e-2;
dx=2e-4;
xq=X_w-a:dx:X_w+a;
Z_r=zeros(length(xq),1);
%irregularity long. profile in the contact patch
X_irr = X_w0:inp.solver.Vx*inp.solver.deltat:(X_w0+inp.solver.Vx*inp.solver.deltat*inp.solver.n_ts);
Z_irr = interp1(X_irr,ver_irr,xq,'pchip');

%rail long. profile in the contact patch
for i=1:length(xq)
    shape = form_shape_fun(geo,mat_trk,[xq(i),railID*0.75,0]);
    Z_r(i,1) = shape*ver_dis_r';
end

Z_r=Z_r-ver_dis_w; %colonm vector to row vector
%


Rw0=inp.geo.Rw/2;
Z_w=Rw0-sqrt(Rw0^2-(xq-X_w).^2);

delta= Z_r(:,1)+Z_irr(:,1)-Z_w';
k=0.5*inp.mater(1).Data(1)/(1-0.27^2);
index = delta >0;
delta=index.*delta;


f=k*dx*delta;
Fn= sum(f);
Fn=[Fn,0];



end