function [H1, fxx] = black_box_model(kp,kb,num_elem_slp)
%%
% black_box_model: calculates FRF based on hammer test
% INPUT:
%   kp - railpad stiffness
%   
%   kb - ballast stiffness
%   num_elem_slp - number of elements in one sleeper, should be an
%   integral and greater than 1
% OUTPUT:
% 	H1 - FRF (point receptance, complex value)
%  fxx - frequency points correponding to FRF
% USAGE EXAMPLE:
% see example_black_box_optimization.mlx
% 



% get input parameters
[inp,NNslpf] = get_input_4(); % default input parameters
if nargin == 3
inp.mesh.m_1S_Int = num_elem_slp;
NEslph=(2*inp.mesh.m_1S_Ext+inp.mesh.m_1S_Int)/2; %number of elements for half sleeper
NNslpf=NEslph*2+1;
end
% geometry
[nodeCoord] = node_coor(inp); % form nodes
btypr = inp.mesh.btypr;       % element type for rail
btyps = inp.mesh.btyps;       % element type for sleeper
[geo] = mesh_trk_full(btypr,btyps,nodeCoord); % mesh geometry

% modify railpad and ballast stiffness and damping (parameters to be optimized)

inp.mater(3).Data(1) = kp;
% inp.mater(3).Data(2) = cp;
inp.mater(4).Data(1) = kb / NNslpf;
% inp.mater(4).Data(2) = cb / NNslpf;

% form system matrix
% mat_ws=form_mat_ws(inp);                      % wheelset matrix
mat_trk = form_mat_trk_2(inp,geo);            % form track matrix

% calculate hammer response
[H1,fxx] = hammer_main_snst_mcs(inp,mat_trk,geo);