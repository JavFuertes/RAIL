function mat=assemble_mat(mat_trk, mat_vhcl, geo,r_w,x_w, z_w,z_r,z_irr)
numDof=length(mat_trk.activeDof)+length(mat.dof);
stiffness=zeros

if z_w-z_r-z_irr >= r_w
    %no wheel rail contact, the system is decoupled
    stiffness=blkdiag(mat_vhcl.K,mat_trk.K_reduced);
    mass=blkdiag(mat_vhcl.M,mat_trk.M_reduced);
else
    %wheel/rail in contact
     
end
