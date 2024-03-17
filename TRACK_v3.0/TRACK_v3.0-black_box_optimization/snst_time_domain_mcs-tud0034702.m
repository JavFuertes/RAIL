% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Sensitivity analysis time domain
% % Using Monte Carlo simumlations
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%%
 filename=['snst_dynamic_mcs_normal_uniform_1ksamples_G_Kpad_random.mat'];
[inp,NNslpf] = get_input_4();
[nodeCoord] = node_coor(inp);
btypr = inp.mesh.btypr;
btyps = inp.mesh.btyps;
[geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_ws=form_mat_ws(inp);
% refval = [210e9;7.0515e-3;74.6e9;0.043;1.3e9;6.75e4;9e7/NNslpf;6.4e4/NNslpf];
% setnum = [1,1;1,3;2,1;2,3;3,1;3,2;4,1;4,2];
% setnumC1 = setnum(:,1);
% setnumC2 = setnum(:,2);
% S = struct('F',zeros(1001,2)); % Results

setnum = [1,1;1,3;2,1;2,3;3,1;3,2;4,1;4,2];
valRange = [5.019e6,5.021e6;  % Rail EI
            56,56.001;         % Rail rhoA
            1.029e7,1.031e7; % Sleeper EI
            1.05e2,1.58e2; % Sleeper rhoA
            1e8,1.3e9;     % Railpad Stiffness 1e8,1.5e9;
            6.749e4,6.751e4;       % Railpad damping
            8.99e7/NNslpf, 9.01e7/NNslpf;
            6.39e4/NNslpf, 6.41e4/NNslpf;
            0.5e-3 5e-3;
            10e-3 150e-3 ];
% valRange = [4.75e6,5.25e6;  % Rail EI
%             51.3,56.7;         % Rail rhoA
%             5.53e6,1.12e7; % Sleeper EI
%             1.05e2,1.58e2; % Sleeper rhoA
%             1e8,1.3e9;     % Railpad Stiffness 1e8,1.5e9;
%             1e4,7e4;       % Railpad damping
%             6e7/NNslpf, 28e7/NNslpf;
%             4e4/NNslpf, 28e4/NNslpf];
refval = sum(valRange,2)./2;
range = valRange(:,2)-valRange(:,1);
setnumC1 = setnum(:,1);
setnumC2 = setnum(:,2);
N = 1000; %number of samples
nPara = 10;
S1 =zeros(inp.solver.n_ts+1,N); % Results
S2 =zeros(inp.solver.n_ts+1,N);
distrTpye = 1;

%% Generate random inputs
switch distrTpye
    case 1
% % Uniform distribution

p = sobolset(nPara);
h = p(1:N,:);
range1 = repmat(range',size(h,1),1);
    
    
randInp = repmat(valRange(:,1)',size(h,1),1) + range1.*h;

clear p h
    case 2
        % Normal distribution
Std = (valRange(:,2)-valRange(:,1))./6;
Sigma = diag(Std.^2); % standard deviation;
randInp = lhsnorm(refval, Sigma, N);
end
% % Disable when considering irr geometry as varibles
%     irr_depth=0.2e-3;
%     irr_length=30e-3;
%     %

%% Start MCS
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
    S2(:,nsim)=F(:,2);
    %S(npara).dis=[dis_out,dis.w];
    %S(npara).vel=[vel_out,vel.w];
    %S(npara).acc=[acc_out,acc.w];
    
    disp (['Simulation No. ',num2str(nsim),' finished. Time: ' datestr(now)]);
end

    save (filename)%, 'geo', 'inp', 'refval', 'randInp', 'S1');

