function [acc,vel,dis,F,t]=interaction_iteration(mat_trk, mat_vhcl, inp,geo,x_w, z_w,z_r,z_irr,v)
%initial condition

m_w=inp.mater.m_unsprg;
t=0:inp.solver.deltat:inp.solver.deltat*inp.solver.n_ts;
for i=1:inp.solver.n_ts
if z_w-z_r-z_irr >= r_w
    %no wheel rail contact, the system is decoupled
    
    
    
    
    
    
    
end
