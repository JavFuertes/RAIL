% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Sensitivity analysis time domain
% % Using Monte Carlo simumlations
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear
%%
filename='snst_wave_3k_8_variables_norm_stiffpad.mat';
[inp,NNslpf] = get_input_4();
[nodeCoord] = node_coor(inp);
btypr = inp.mesh.btypr;
btyps = inp.mesh.btyps;
[geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_ws=form_mat_ws(inp);
mat_trk = form_mat_trk_2(inp,geo);
paraNumOpt = [5 7];
% refval = [210e9;7.0515e-3;74.6e9;0.043;1.3e9;6.75e4;9e7/NNslpf;6.4e4/NNslpf];

setnum = [1,1;1,3;2,1;2,3;3,1;3,2;4,1;4,2];
valRange = [4.75e6,5.25e6;  % Rail EI
            51.3,56.7;         % Rail rhoA
            5.53e6,1.12e7; % Sleeper EI
            1.05e2,1.58e2; % Sleeper rhoA
            1.3e9,2e9;     % Railpad Stiffness 1e8,1.5e9;
            1e4,7e4;       % Railpad damping
            6e7/NNslpf, 28e7/NNslpf;
            4e4/NNslpf, 28e4/NNslpf];
refval = sum(valRange,2)./2;
range = valRange(:,2)-valRange(:,1);
setnumC1 = setnum(:,1);
setnumC2 = setnum(:,2);
N = 3000; %number of samples
nPara = 8;
SfrqEigb = zeros(length(mat_trk.K_reduced),N);
Swavenum = zeros(length(mat_trk.K_reduced),N); % Results
distrTpye = 2;
if distrTpye == 3
randInpPre = repmat(pmRef,50,1);
randInpPre(:,paraNumOpt(1)) = population(:,1); %!! population has to be predifined 
randInpPre(:,paraNumOpt(2)) = population(:,2);
end


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
        Std = (valRange(:,2)-valRange(:,1))./4;
        Sigma = diag(Std.^2); % standard deviation;
        randInp = lhsnorm(refval, Sigma, N);
    case 3
        % Predifined distribution
        randInp = randInpPre;
end

%% Start MCS
for nsim = 1:N
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
    
    Kr=round(full(mat_trk.K_reduced),-1);
    Mr=round(full(mat_trk.M_reduced),12);
    if issymmetric(Kr) && issymmetric(Mr)
        [V,D]=eig(Kr,Mr);
    frqEigb=abs(sqrt(diag(D)));
    frqEigb=frqEigb./(2*pi());
    indNodeRail = geo.ND(:,5) == 1;
    x=geo.ND(indNodeRail,2);
    [wavenum,fv,Vq,xq]=shape2dispersion(V(1:2:sum(indNodeRail == 1)*2,:),x',2048);
    
    SfrqEigb(:,nsim) = frqEigb;
    Swavenum(:,nsim) = wavenum(:,2);
    else
        V = zeros(size(full(mat_trk.K_reduced)));
        D = eye(size(full(mat_trk.K_reduced)));
        disp(['Kr or Mr is asymmetric for simulation No. ', num2str(nsim)]);
    end
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
    save (filename, 'geo', 'inp', 'refval', 'randInp', 'SfrqEigb','Swavenum');
end

