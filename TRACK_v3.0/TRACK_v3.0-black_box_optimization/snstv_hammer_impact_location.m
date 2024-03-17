% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Sensitivity analysis of hammer test at different locations
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
inp = get_input_4();
para = [6.3,6.4,6.5,6.6];%[0.8 0.9 1 1.1 1.2];%[0.8 0.9 1 1.1 1.2];%linspace(0.1,2,20);%[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8];

% para = [0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3];

refval = inp.ext_force.x;
btypr = inp.mesh.btypr;
btyps = inp.mesh.btyps;
[nodeCoord] = node_coor(inp,0);
mat_ws=form_mat_ws(inp);
S=struct('F',zeros(10,2),'dis',zeros(10,2),'vel',zeros(10,2),'acc',zeros(10,2));

for npara = 1:length(para)
    inp.ext_force.x(1) = para(npara);
    [geo] = mesh_trk_full(btypr,btyps,nodeCoord);
    mat_trk = form_mat_trk_2(inp,geo);

    %hammer test main program    
    [dis, vel,acc, t, force]=solver_newmark(inp,mat_trk,geo);


X_load=inp.ext_force.x;
if X_load(3)==0
%shape function 1 on rail
[shape,Ref_Dof]=form_shape_fun(geo,mat_trk,X_load);

else%shape funciton 2 impact on sleeper
shape=zeros(1,length(mat_trk.K_reduced));
nodeNumber=107;dofID=1;
dof=2*(nodeNumber-1)+dofID;
ind=ismember(mat_trk.activeDof,dof);
shape(1,ind)=1;
end

dis_x_load=dis*shape';
%post-processing
w=genexpwin(10000);
[H1,H2,~,pxx,pxy,fxx]=tran_fun([force(1:10000)',dis_x_load(1:10000)],w,0,25600,102400);
 
    
    S(npara).F=force;
    S(npara).dis=dis_x_load;
    S(npara).H1=H1;
    S(npara).fxx=fxx;
    S(npara).pxx=pxx;
end
filename=['snst_hammer_location_ref_full.mat'];
save (filename, 'geo', 'inp', 'para', 'refval', 'S');
% clear;