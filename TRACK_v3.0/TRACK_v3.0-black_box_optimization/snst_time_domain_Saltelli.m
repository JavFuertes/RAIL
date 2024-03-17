% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Sensitivity analysis time domain
% % Using Monte Carlo simumlations based on 
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
[inp,NNslpf] = get_input_4();
[nodeCoord] = node_coor(inp);
btypr = inp.mesh.btypr;
btyps = inp.mesh.btyps;
[geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_ws=form_mat_ws(inp);
refval = [210e9;7.0515e-3;74.6e9;0.043;1.3e9;6.75e4;9e7/NNslpf;6.4e4/NNslpf];
setnum = [1,1;1,3;2,1;2,3;3,1;3,2;4,1;4,2];
setnumC1 = setnum(:,1);
setnumC2 = setnum(:,2);
% S = struct('F',zeros(1001,2)); % Results


%% Generate random inputs
% randInp = zeros(8,100);
% p = sobolset(1);
% for npara = 1:8
    
%     h = p(100*(npara-1)+1:100*(npara-1)+100);
%     randInp(npara,:) = refval(npara).* (0.2+1.8*h');
% end
% clear p h

Std = refval*0.1; % standard deviation
Sigma = diag(Std.^2); % standard deviation;
N = 100; %number of samples
randInp = lhsnorm(refval, Sigma, N);

% Saltelli's single loop method
A = randInp;
B = lhsnorm(refval, Sigma, N);
%% Start MCS
tic
[sen_vector_first,sen_vector_total,F]= Sen_FirstOrder_Saltelli(A, B, @snst_maxF_dynamic_model,inp,mat_ws,geo,N,setnumC1,setnumC2);
disp (['Finished. Time' num2str(toc)]);
% Total_effects_Saltelli = Sen_TotalEffect_Saltelli(A, B, @snst_maxF_dynamic_model,inp,mat_ws,geo,N,setnumC1,setnumC2);

    % filename=['snst_G302_6.5m_mcs.mat'];
    % save (filename, 'geo', 'inp', 'refval', 'randInp', 'S');

