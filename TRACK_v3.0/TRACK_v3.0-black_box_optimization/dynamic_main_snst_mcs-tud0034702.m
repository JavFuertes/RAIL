%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Main program: dynamic analysis
%%%Author: Chen Shen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear;
% %%
% %%build track model

%%
%%initial conditions
function F = dynamic_main_snst_mcs(inp,mat_trk,geo,mat_ws,irr_depth,irr_length)
acc.r=zeros(inp.solver.n_ts+1,length(mat_trk.K_reduced));
vel.r=zeros(inp.solver.n_ts+1,length(mat_trk.K_reduced));
dis.r=zeros(inp.solver.n_ts+1,length(mat_trk.K_reduced));
acc.w=zeros(inp.solver.n_ts+1,2);
vel.w=zeros(inp.solver.n_ts+1,2);
dis.w=zeros(inp.solver.n_ts+1,2);
Z.w=zeros(inp.solver.n_ts+1,2);
Z.r=zeros(inp.solver.n_ts+1,2);
Z.irr=zeros(inp.solver.n_ts+1,2); %can be read in with files
F=zeros(inp.solver.n_ts+1,2);
X_w=zeros(inp.solver.n_ts+1,1);
X_w(1,1)=6;   %initial x coordinates of wheel
vx=inp.solver.Vx; %vehicle speed
contactID=5; %5 for non-linear  10 for linear 8 for winkler bedding 
zdd=load(inp.ext_force.timeh);
Fex=zeros(length(zdd),2);
if isempty(mat_ws)
    mc_ws=zeros(inp.solver.n_ts+1,1);
else
mc_ws=zeros(inp.solver.n_ts+1,size(mat_ws.A,1)); %modal coordinates for flexible wheelset model
end

%%
%%irregularity definition

        %%irregularity definition: squat G302 maria
%         irr_depth=0.2e-3;
%         irr_length=30e-3;
        irr_x0=6.5; %30.38=15.38=0.98 in FE 15.5=1.1
        irr_ts0=round((irr_x0-X_w(1,1))/vx/inp.solver.deltat);
        irr_ts1=round((irr_x0-X_w(1,1)+1*irr_length)/vx/inp.solver.deltat);
        
        %%irregularity definition: wheelflat benchmark
%         irr_depth=0.3e-3;
%         irr_length=50e-3;
%         irr_x0=30.575;
%         irr_ts0=round((irr_x0-X_w(1,1))/vx/inp.solver.deltat);
%         irr_ts1=round((irr_x0-X_w(1,1)+irr_length)/vx/inp.solver.deltat);
%          
%         
        
        for i=irr_ts0:1:irr_ts1           
            Z.irr(i,1)=irr_depth./2*(cos(2*pi./irr_length*(vx*inp.solver.deltat*i-(irr_x0-X_w(1,1))))-1);
        end
        
% % %         %%irregularity definition: dipped joint
% % %         irr_depth=3.5e-3;
% % %         irr_length=1;
% % %         irr_x0=6.1; %30.38=15.38=0.98 in FE 15.5=1.1
% % %         irr_ts0=round((irr_x0-X_w(1,1))/vx/inp.solver.deltat);
% % %         irr_ts1=round((irr_x0-X_w(1,1)+irr_length)/vx/inp.solver.deltat);
% % %         
% % %         for i=irr_ts0:1:round(irr_ts1/2)
% % %             Z.irr(i,1)=-irr_depth.*(vx*inp.solver.deltat*i-(irr_x0-X_w(1,1)))/(irr_length/2);
% % %         
% % %         end
% % %         for i=round(irr_ts1/2)+1:irr_ts1
% % %         Z.irr(i,1)=-irr_depth.*(irr_length-(vx*inp.solver.deltat*i-(irr_x0-X_w(1,1))))/(irr_length/2);
% % %         end

Z.irr(:,2)=zeros(length(Z.irr(:,1)),1);%irregularity on the other rail 

%%
%%irregularity definition: measured
% load('measured_geometry_squat_Molodova_2014.mat', 'irr'); 
% irr_length=200e-3;
% irr_x0=30.2; %30.38=0.98 in FE
% irr(:,3)=irr_x0+irr(:,1);
% irr_ts0=round((irr_x0-X_w(1,1))/vx/inp.solver.deltat);
% irr_ts1=round((irr_x0-X_w(1,1)+irr_length)/vx/inp.solver.deltat);
% 
% for i=irr_ts0:1:irr_ts1;
% xq=vx*inp.solver.deltat*i+X_w(1,1);
% 
% Z.irr(i,1)=interp1(irr(:,3),irr(:,2),xq,'linear','extrap');
% end
%%
    
 
%%shape function for initial condition
% shape_initial=form_shape_fun(geo,mat_trk,[X_w(1,1),-0.75,0]);
shape_initial(1,:)=form_shape_fun(geo,mat_trk,[X_w(1,1),-0.75,0]);
shape_initial(2,:)=form_shape_fun(geo,mat_trk,[X_w(1,1),0.75,0]);

%static analysis
[dis_initial,Z_initial,F_initial]=solver_static(mat_trk,inp,shape_initial,contactID);
dis.r(1,:)=dis_initial.r;
dis.w(1,:)=dis_initial.w;
Z.r(1,:)=Z_initial.r;

Z.w(1,:)=Z_initial.w;

F(1,:)=F_initial;



    
    
%%
%dynamic analysis
%disp (['Starting Newmark intergration. Time: ' datestr(now)]);
% tic;
for i=1:inp.solver.n_ts
    X_w(i+1,1)=X_w(1,1)+i*inp.solver.deltat*vx;
    shape(1,:)=form_shape_fun(geo,mat_trk,[X_w(i+1,1),-0.75,0]);
    shape(2,:)=form_shape_fun(geo,mat_trk,[X_w(i+1,1),0.75,0]);
     
    acc1.r=acc.r(i,:);
    vel1.r=vel.r(i,:);
    dis1.r=dis.r(i,:);
    acc1.w=acc.w(i,:);
    vel1.w=vel.w(i,:);
    dis1.w=dis.w(i,:);
    position.w=Z.w(i,:);
    position.r=Z.r(i,:); 
    position.irr=Z.irr(i,:);
    mc_ws1=mc_ws(i,:)';
    
     
    
    [acc2,vel2,dis2,F_contact,position,mc_ws2]=solver_newmark_iter(mat_trk,inp,shape,...
        position, inp.ext_force.wh_ld, acc1, vel1, dis1,mc_ws1,X_w(i+1,1), geo, Z,contactID,Fex(i,:),mat_ws);
    
    mc_ws(i+1,:)=mc_ws2';
    acc.r(i+1,:)=acc2.r;
    vel.r(i+1,:)=vel2.r;
    dis.r(i+1,:)=dis2.r;
    acc.w(i+1,:)=acc2.w;
    vel.w(i+1,:)=vel2.w;
    dis.w(i+1,:)=dis2.w;
    Z.w(i+1,:)=position.w;
    Z.r(i+1,:)=position.r;
%     Z.irr(i+1,1)=position.irr;
    F(i+1,:)=F_contact;
    % if ismember(i,1000*linspace(1,10,10))
    %     disp (['Time step: ' num2str(i) 'finished. Time' num2str(toc)]);
    % end
end

%%
% figure;
% plot(X_w,F);

%%
% clear acc1 acc2 dis1 dis2 dis_initial i position shape vel1 vel2;