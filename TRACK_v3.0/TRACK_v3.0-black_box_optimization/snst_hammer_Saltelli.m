% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Sensitivity analysis time domain
% % Using Monte Carlo simumlations based on 
% % Author: Chen Shen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clear('all');

filename=['snst_hammer_midspan_Saltelli_uniform_rail_constrain_1ksamples_softpad.mat'];
[inp,NNslpf] = get_input_4();
[nodeCoord] = node_coor(inp);
btypr = inp.mesh.btypr;
btyps = inp.mesh.btyps;
[geo] = mesh_trk_full(btypr,btyps,nodeCoord);
mat_ws=form_mat_ws(inp);
% refval = [210e9;7.0515e-3;74.6e9;0.043;1.3e9;6.75e4;9e7/NNslpf;6.4e4/NNslpf];

setnum = [1,1;1,3;2,1;2,3;3,1;3,2;4,1;4,2];
valRange = [4.75e6,5.25e6;  % Rail EI
            51.3,56.7;         % Rail rhoA
            5.53e6,1.12e7; % Sleeper EI
            1.05e2,1.58e2; % Sleeper rhoA
            2e8,1.5e9;     % Railpad Stiffness 1e8,1.5e9;
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
distrTpye = 2;


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


% Saltelli's single loop method
A = lhsnorm(refval, Sigma, N);
B = lhsnorm(refval, Sigma, N);
A = abs(A);
B = abs(B);
%% Start MCS
tic
[sen_vector_first,sen_vector_total]= Sen_FirstOrder_Saltelli_multiple(A, B, @snst_hammer_model,inp,geo,N,setnumC1,setnumC2);
disp (['Finished. Time' num2str(toc)]);


% Check if filename already ex
if ismember(cellstr(filename),cellstr(ls))
    prompt=[filename '.mat exists. Overwrite?(n/y)\n'];
    ow = input(prompt);
%     if isempty(ow)
%         ow='n';
%     end
    if ow == 'y'
        save (filename);
    end
else
    save (filename);
end
   
