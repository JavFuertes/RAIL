% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Sensitivity analysis using hammer test
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inp = get_input_4();
para = logspace(-1,1,10);%linspace(0.1,1.1,10);%para = [0.9,1,1.1];linspace(0.1,2,20);%[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8];
para = round(para,1);
% para = [0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3];
nmat = 4;
ndata = 1; 
refval=inp.mater(nmat).Data(ndata);
btypr=inp.mesh.btypr;
btyps=inp.mesh.btyps;
[nodeCoord] = node_coor(inp);
S=struct('H1',zeros(10,1));
% S1=struct('frq',zeros(10,1));

w=genexpwin(1000);

for i = 1:length(para)
   inp.mater(nmat).Data(ndata)= para(i)*refval;
[geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_trk = form_mat_trk_2(inp,geo);

hammer_main;

[H1,H2,~,pxx,pxy,fxx]=tran_fun([force(1:1000)',dis_x_load(1:1000)],w,0,25600,25000);
S(i).H1=H1;

end

% for i = 1:length(para)
% frqout=clean_up(S(i).frq(2:15),30);
% frqout=[S(i).frq(1);frqout];
% S1(i).frq=frqout;
% end
% 
% function seq_out=clean_up(seq,tol)
% diff=seq(2:end)-seq(1:end-1);
% ind=diff<tol;
% ind=[0; ind];
% seq_out=seq(~ind);
% end