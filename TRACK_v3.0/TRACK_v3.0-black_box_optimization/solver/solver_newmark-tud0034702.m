%linear solver for track model subjected to external load, e.g. hammer test
%or moving load
function [dis, vel,acc, t, zdd]=solver_newmark(in_data,sys_mat,geo,dlt,alf)
%data read in
if nargin >4
    delta=dlt;
    alpha=alf;
else
    delta=0.5;
    alpha=0.25;
end

deltat=1/in_data.ext_force.sf;
tx=[0:1/25600:1];
t=[0:deltat:1];

K=sys_mat.K_reduced;
M=sys_mat.M_reduced;
if isfield(sys_mat,'C_reduced')==1
    C=sys_mat.C_reduced;
else
    C=sparse(zeros(length(sys_mat.K_reduced),length(sys_mat.K_reduced)));
end
dof=length(sys_mat.K_reduced);

zdd=load(in_data.ext_force.timeh);
zdd=interp1(tx,zdd,t);

points=length(zdd);






a0=1/(alpha*deltat^2);
a1=delta/(alpha*deltat);
a2=1/(alpha*deltat);
a3=(1/(2*alpha))-1;
a4=(delta/alpha)-1;
a5=(deltat/2)*((delta/alpha)-2);
a6=deltat*(1-delta);
a7=delta*deltat;

K=K+a0*M+a1*C;

[L,D,P]=ldl(K);

dis = zeros(length(zdd)-1,dof);
vel = zeros(length(zdd)-1,dof);
acc = zeros(length(zdd)-1,dof);



% %initial conditions
% dis(1,:)=initial.dis;
% vel(1.:)=initial.vel;
% acc(1,:)=initial.acc;

% t=(0:points-1)*deltat;
disp (['Starting Newmark intergration. Time: ' datestr(datetime('now'))]);
tic;
if in_data.ext_force.Vx==0
   coor_load=in_data.ext_force.x;
    if coor_load(:,3)==0%shape function 1 on rail
        shape=form_shape_fun(geo,sys_mat,coor_load);
%         disp('ok');
    else%shape funciton 2 impact on sleeper
        shape=zeros(1,length(K));
        nodeNumber=1183;dofID=1; %nodeNumber=107;dofID=1;
        dofShape=2*(nodeNumber-1)+dofID;
        ind=ismember(sys_mat.activeDof,dofShape);
        shape(1,ind)=1;
    end
end
for i=1:in_data.solver.n_ts
    if in_data.ext_force.Vx~=0
    coor_load=in_data.ext_force.x+[in_data.ext_force.Vx*i,0,0];
    if coor_load(:,3)==0%shape function 1 on rail
        shape=form_shape_fun(geo,sys_mat,coor_load);
%         disp('ok');
    else%shape funciton 2 impact on sleeper
        shape=zeros(1,length(K));
        nodeNumber=1177;dofID=1; %nodeNumber=107;dofID=1;
        dofShape=2*(nodeNumber-1)+dofID;
        ind=ismember(sys_mat.activeDof,dofShape);
        shape(1,ind)=1;
    end
    end
    %     R= zdd(i+1)*shape';
    R=  zdd(i+1)*shape';
    R = R + M*(a0*dis(i,:)'+a2*vel(i,:)'+a3*acc(i,:)')+ C*(a1*dis(i,:)'+a4*vel(i,:)'+a5*acc(i,:)');
    
    switch in_data.solver.linsolver_id
        case 1 %LDL
            Y=(L*P)'*R;
            Z=D'*Y;
            dis(i+1,:)=(P*L)*Z;
            
        case 2 %mldivide
            dis(i+1,:)=(K\R)';
    end
    
    acc(i+1,:) = a0*(dis(i+1,:)-dis(i,:)) - a2*vel(i,:) - a3*acc(i,:);
    vel(i+1,:) = vel(i,:) + a6*acc(i,:) + a7*acc(i+1,:);
    if ismember(i,1000*linspace(1,10,10))
    disp (['Time step: ' num2str(i) 'finished. Time' num2str(toc)]);
    end
end




end