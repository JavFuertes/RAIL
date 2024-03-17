% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Sensitivity analysis time domain
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for nsim=5:5
setnum=[1,1;1,3;2,1;2,3;3,1;3,2;4,1;4,2];    
inp = get_input_4();
para = logspace(-1,1,10);%[0.8 0.9 1 1.1 1.2];%[0.8 0.9 1 1.1 1.2];%linspace(0.1,2,20);%[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8];
para = round(para,1);
% para = [0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3];
nmat = setnum(nsim,1);
ndata = setnum(nsim,2); 
refval=inp.mater(nmat).Data(ndata);
btypr=inp.mesh.btypr;
btyps=inp.mesh.btyps;
[nodeCoord] = node_coor(inp);
nodeout=[265,607];
% nodeout=[265,746,1198,1210];
mat_ws=form_mat_ws(inp);
S=struct('F',zeros(10,2),'dis',zeros(10,2),'vel',zeros(10,2),'acc',zeros(10,2));


for npara = 1:length(para)
   inp.mater(nmat).Data(ndata)= para(npara)*refval;
   
inp.mater(1).Data(5)=inp.mater(1).Data(1)/(2*(1+0.3));
inp.mater(2).Data(5)=inp.mater(1).Data(1)/(2*(1+0.17));

   [geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_trk = form_mat_trk_2(inp,geo);

dynamic_main_snst;
[dis_out,vel_out,acc_out,index,nodeRef] = time_history(nodeout,mat_trk.activeDof,dis.r,vel.r,acc.r);

S(npara).F=F;
S(npara).dis=[dis_out,dis.w];
S(npara).vel=[vel_out,vel.w];
S(npara).acc=[acc_out,acc.w];



end
filename=['snst_G202_6.5m_ref2_',num2str(nmat),num2str(ndata),'.mat'];
save (filename, 'geo', 'inp', 'ndata', 'nmat', 'para', 'refval', 'S', 'Z');
clear;
end
