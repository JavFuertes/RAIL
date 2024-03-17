% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Main program for TRACK model without input requirement
% % Author: Luca Sabbatini and Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inp = get_input_4();
para = linspace(0.1,2,20);%[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8];
para = round(para,1);
% para = [0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3];
nmat = 1;
ndata = 4;
refval=inp.mater(nmat).Data(ndata);
btypr=inp.mesh.btypr;
btyps=inp.mesh.btyps;
[nodeCoord] = node_coor(inp);
S=struct('frq',zeros(10,1));
S1=struct('frq',zeros(10,1));

for i = 1:length(para)
   inp.mater(nmat).Data(ndata)= para(i)*refval;
[geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_trk = form_mat_trk_2(inp,geo);

Kr=round(full(mat_trk.K_reduced),-1);
Mr=round(full(mat_trk.M_reduced),14);
if ~issymmetric(Mr)
    return
end

[V,D]=eig(Kr,Mr);
frqEigb=abs(sqrt(diag(D)));
frqEigb=frqEigb./(2*pi());
% dr=0.01*ones(1000,1);
% wi=linspace(1,2*pi*5000,1000);
% frq=wi./(2*pi);
x=geo.ND(1:481,2);
[wavenum,fv,Vq,xq]=shape2dispersion(V(1:2:481*2,:),x',2048);
% plot(frqEigb,wavenum(:,2),'c^');
ind_cuton=wavenum(:,2)>0.02 & wavenum(:,2)<0.03 ;
frqEigCut=frqEigb(ind_cuton);
S(i).frq=frqEigCut;

% save('temp.mat','-struc','S');
disp(num2str(i));
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