%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Main program: falling wheel simulation
%%%Author: Chen Shen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

%build track model
TRACK_main2;

%initial conditions


acc.r=zeros(inp.solver.n_ts+1,length(mat_trk.K_reduced));
vel.r=zeros(inp.solver.n_ts+1,length(mat_trk.K_reduced));
dis.r=zeros(inp.solver.n_ts+1,length(mat_trk.K_reduced));
acc.w=zeros(inp.solver.n_ts+1,1);
vel.w=zeros(inp.solver.n_ts+1,1);
dis.w=zeros(inp.solver.n_ts+1,1);
Z.w=zeros(inp.solver.n_ts+1,1);
Z.r=zeros(inp.solver.n_ts+1,1);
Z.irr=zeros(inp.solver.n_ts+1,1); %can be read in with files
F=zeros(inp.solver.n_ts+1,1);

acc.w(1,1)= -9.8;%-9.8;
vel.w(1,1)= -1.98;%-2.425;%-0.99; %vertical impact velocity
dis.w(1,1)= 0.003;



X_w=15.3; % x coordinate of wheel

contactID=5 ;


% shape=zeros(1,length(mat_trk.K_reduced)); %can be modified using shape function
% shape(1,299)=1;
shape=form_shape_fun(geo,mat_trk,[X_w,-0.75,0]);

%initial velocity of rail nodes
% vel.r(1,:)=20.99*shape';
%

disp (['Starting Newmark intergration. Time: ' datestr(now)]);
tic;
for i=1:inp.solver.n_ts
    acc1.r=acc.r(i,:);
    vel1.r=vel.r(i,:);
    dis1.r=dis.r(i,:);
    acc1.w=acc.w(i,1);
    vel1.w=vel.w(i,1);
    dis1.w=dis.w(i,1);
    position.w=Z.w(i,1);
    position.r=Z.r(i,1);
    position.irr=Z.irr(i,1);
    
    
    [acc2,vel2,dis2,F_contact,position]=solver_newmark_iter(mat_trk,inp,shape,...
        position, inp.ext_force.wh_ld, acc1, vel1, dis1,X_w,geo,Z,contactID);
   
    acc.r(i+1,:)=acc2.r;
    vel.r(i+1,:)=vel2.r;
    dis.r(i+1,:)=dis2.r;
    acc.w(i+1,1)=acc2.w;
    vel.w(i+1,1)=vel2.w;
    dis.w(i+1,1)=dis2.w;
    Z.w(i+1,1)=position.w;
    Z.r(i+1,1)=position.r;
    Z.irr(i+1,1)=position.irr;
    F(i+1,1)=F_contact;
    
    disp (['Time step: ' num2str(i) 'finished. Time' num2str(toc)]);
    
end
clear acc1 acc2 dis1 dis2 i position shape vel1 vel2;
Fm=max(F);
% figure;
% plot(F);

