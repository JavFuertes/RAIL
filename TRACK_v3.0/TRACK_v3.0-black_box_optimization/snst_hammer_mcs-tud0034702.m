% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Sensitivity analysis time domain
% % Using Monte Carlo simumlations
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%%
 filename=['snst_hammer_onsup_mcs_uniform_UIC60_slp_spacing6.5_1ksamples_half_rigid_sleeper.mat'];
[inp,NNslpf] = get_input_2();
[nodeCoord] = node_coor(inp,1);
btypr = inp.mesh.btypr;
btyps = inp.mesh.btyps;
[geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_ws=form_mat_ws(inp);
% refval = [210e9;7.0515e-3;74.6e9;0.043;1.3e9;6.75e4;9e7/NNslpf;6.4e4/NNslpf];

setnum = [1,1;1,3;2,1;2,3;3,1;3,2;4,1;4,2];
valRange = [6.3e6,6.5e6;  % Rail EI
            59,61;         % Rail rhoA
            1.10e9,1.12e9; % Sleeper EI
            1.05e2,1.58e2; % Sleeper rhoA
            1e8,1.5e9;     % Railpad Stiffness 1e8,1.5e9;
            1e4,7e4;       % Railpad damping
            6e7/NNslpf, 28e7/NNslpf;
            4e4/NNslpf, 28e4/NNslpf];
refval = sum(valRange,2)./2;
range = valRange(:,2)-valRange(:,1);
setnumC1 = setnum(:,1);
setnumC2 = setnum(:,2);
N = 1000; %number of samples
nPara = 8;
S =zeros(12801,N); % Results
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
    
    mat_trk = form_mat_trk_2(inpOne,geo);
    
%     if nsim ==1
%     [H1,fxx] = hammer_main_snst_mcs(inpOne,mat_trk,geo);
%     else
         H1 = hammer_main_snst_mcs(inpOne,mat_trk,geo);
%     end
    
    S(:,nsim)=H1;
    %S(npara).dis=[dis_out,dis.w];
    %S(npara).vel=[vel_out,vel.w];
    %S(npara).acc=[acc_out,acc.w];
    
    disp (['Simulation No. ',num2str(nsim),' finished. Time: ' datestr(now)]);
end

% Check if filename already ex
if ismember(cellstr(filename),cellstr(ls))
    prompt=[filename '.mat exists. Overwrite?(n/y)\n'];
    ow = input(prompt);
%     if isempty(ow)
%         ow='n';
%     end
    if ow == 'y'
        save (filename, 'geo', 'inp', 'refval', 'randInp', 'S');
    end
else
    save (filename, 'geo', 'inp', 'refval', 'randInp', 'S');
end

