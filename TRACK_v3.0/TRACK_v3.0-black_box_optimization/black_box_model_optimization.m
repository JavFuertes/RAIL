function H1 = black_box_model_optimization(para,frq_range)
%%
% black_box_model_optimization: calculates the 
% INPUT:
%   para(1) - railpad stiffness
%   para(2) - railpad damping
%   para(3) - ballast stiffness
%   para(4) - ballast damping
%   frq_range - frequency range of interest (as indexes)
% OUTPUT:
% 	H1 - FRF in the frequency range of interest (point receptance, complex value)
%  
% USAGE EXAMPLE:
% see example_black_box_optimization.mlx
% 

% get input parameters
[inp,NNslpf] = get_input_4(); % default input parameters

% geometry
[nodeCoord] = node_coor(inp); % form nodes
btypr = inp.mesh.btypr;       % element type for rail
btyps = inp.mesh.btyps;       % element type for sleeper
[geo] = mesh_trk_full(btypr,btyps,nodeCoord); % mesh geometry

% modify railpad and ballast stiffness and damping (parameters to be optimized)
inp.mater(3).Data(1) = para(1);
inp.mater(3).Data(2) = para(2);
inp.mater(4).Data(1) = para(3) / NNslpf;
inp.mater(4).Data(2) = para(4) / NNslpf;

% form system matrix
% mat_ws=form_mat_ws(inp);                      % wheelset matrix
mat_trk = form_mat_trk_2(inp,geo);            % form track matrix

% calculate hammer response
H1 = hammer_main_snst_mcs(inp,mat_trk,geo);
H1 = H1(frq_range);