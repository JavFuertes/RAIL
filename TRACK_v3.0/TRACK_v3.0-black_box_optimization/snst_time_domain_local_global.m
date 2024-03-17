% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Local sensitivity analysis time domain
% % using global generated track parameters
% %
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%%
for npara1 = 1:10
filename=['snst_dynamic_local_global_100_Grandom3_',num2str(npara1),'.mat'];
load('snst_dynamic_mcs_uniform_100_Grandom3.mat', 'randInp');
[inp,NNslpf] = get_input_4();
[nodeCoord] = node_coor(inp);
btypr = inp.mesh.btypr;
btyps = inp.mesh.btyps;
[geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_ws=form_mat_ws(inp);


setnum = [1,1;1,3;2,1;2,3;3,1;3,2;4,1;4,2];

setnumC1 = setnum(:,1);
setnumC2 = setnum(:,2);


%% Generate random inputs



randInp(:,npara1) = randInp(:,npara1).*0.9;



%% Start MCS
N = size(randInp,1);
S1 =zeros(inp.solver.n_ts+1,N); % Results
%S2 =zeros(inp.solver.n_ts+1,N);
parfor nsim = 1:N
    inpOne = inp;
    for npara = 1:8
        nmat = setnumC1(npara);
        ndata = setnumC2(npara);
        if nmat < 3
        inpOne.mater(nmat).Data(ndata)= randInp(nsim,npara)./inpOne.mater(nmat).Data(ndata+1);
    else
        inpOne.mater(nmat).Data(ndata)= randInp(nsim,npara);
        end
    end
    inpOne.mater(1).Data(5)=inpOne.mater(1).Data(1)/(2*(1+0.3));
    inpOne.mater(2).Data(5)=inpOne.mater(2).Data(1)/(2*(1+0.17));
    % Enable when considering irr geometry as varibles
    irr_depth=randInp(nsim,9);
    irr_length=randInp(nsim,10);
    %
    
    mat_trk = form_mat_trk_2(inpOne,geo);
    
    F = dynamic_main_snst_mcs(inpOne,mat_trk,geo,mat_ws,irr_depth,irr_length);
    
    S1(:,nsim)=F(:,1);
    %S2(:,nsim)=F(:,2);
    %S(npara).dis=[dis_out,dis.w];
    %S(npara).vel=[vel_out,vel.w];
    %S(npara).acc=[acc_out,acc.w];
    
    disp (['Simulation No. ',num2str(nsim),' finished. Time: ' datestr(now)]);
end

    save (filename)%, 'geo', 'inp', 'refval', 'randInp', 'S1');
    clear
end


