function mat=form_mat_vhcl(inp)
if inp.mater.M_sprg == 0
    mat.K=0;
    mat.M=inp.mater.M_unsprg;
    mat.dof=1;
else
%vehicle model 2: rigid wheel with sprung mass
    mat.K=inp.mater.K_PS*[1,0;0,-1];
    mat.M=[inp.mater.M_sprg,0;0,inp.mater.M_unsprg];
    mat.dof=[1,2];
end

end