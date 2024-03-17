function mat=form_mat_ws(inp)
filename=inp.mater(6).wsfile;
if isempty(filename) 
    mat=[];
else
[mat.A,mat.B,mat.C,mat.D]=SSMatrix(filename);
end

end
