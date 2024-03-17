%pre-defined data set for coupling simulation

function [in_data] = get_input_scaled(in_data)
%Geometry input

in_data.geo.Ltot_R=6;                  %[m]
in_data.geo.SlpSpc=0.6;      %[m] 
in_data.geo.dist_S=in_data.geo.SlpSpc; %[m] 
in_data.geo.LExt_S=0.5125;              %[m]
in_data.geo.LInt_S=0.750;              %[m]
in_data.geo.Ltot_S=in_data.geo.LExt_S+in_data.geo.LInt_S;      %[m] half length (full length=2.36[m])
in_data.geo.dist_RS=0.2;               %[m] Between rails and sleepers
in_data.geo.dist_SB=0.2;               %[m] Between sleepers and ballast
in_data.geo.Rw=0.46;                   %[m] Wheel radius
in_data.geo.irr=0;                     % Irregularities

%External force

in_data.ext_force.timeh=[ 'example.txt' ];        %time history of external force 
in_data.ext_force.sf=25600;
in_data.ext_force.x=30.3;
in_data.ext_force.Vx=0;
% zdd=load(in_data.ext_force.timeh);
% dof=299;
% in_data.ext_force.dof=ones(length(zdd),1)*dof;       %time history of applied DOF 
in_data.ext_force.wh_ld = 1.2e5;   %[N]

%Solver settings

in_data.solver.n_ts=1000; %length(zdd)-1;                     %Number of time steps
in_data.solver.deltat=1e-4;                   %Time step length
in_data.solver.linsolver_id=2;             %linear solver id, 1 for LDL, 2 for mldivide
in_data.solver.Vx=160/3.6;

%MATERIAL RAIL DATA 
in_data.mater.E_R=210e9;     %[N/m^2]
in_data.mater.I_R=2.3379e-5; %[m^4]
in_data.mater.A_R=6.977e-3;   %[m^3]
in_data.mater.rho_R=7800;    %[kg/m^3]
in_data.mater.G_R=8.1e10;
in_data.mater.kappa_R=0.34;
%MATERIAL SLEEPERS DATA 
in_data.mater.E_S=19.4e9;     %[N/m^2]
in_data.mater.I_S=9.446e-3;  %[m^4]
in_data.mater.A_S=5.3465e-2; %[m^3]
in_data.mater.rho_S=3200;   %[kg/m^3]
in_data.mater.G_S=in_data.mater.E_S/2.3;
in_data.mater.kappa_S=0.833;
%MATERIAL MASS
in_data.mater.M_sprg   = 0;   %4653.5[kg]
in_data.mater.M_unsprg = 725; %[kg]
%MATERIAL SPRING DATA 
in_data.mater.K_Spring_RS = 0.8*1.3e9; %[N/m]
in_data.mater.C_Damper_RS = 4.5e4;   %[N.s/m]
in_data.mater.K_Spring_SB =9e6;  %[N/m]
in_data.mater.C_Damper_SB =6.4e3;  %[N.s/m]
in_data.mater.K_PS        = 1.22e6; %[N/m]
in_data.mater.C_Hertz     = 8.7e10; %[N/m^(3/2)] from (Steffens, 2005)

%MESH PARAMETERS
in_data.mesh.numElem_R_betwSprings=1;   %Number of elements between 2 springs
in_data.mesh.m_1S_Ext=1;                %Number of elements in a sleeper external
in_data.mesh.m_1S_Int=1;                %Number of elements in a sleeper internal
end
