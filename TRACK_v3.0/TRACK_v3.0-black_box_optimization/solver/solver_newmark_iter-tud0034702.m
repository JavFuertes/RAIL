%iteration during one time step
% Z.w=0;
% Z.r=0;
% Z.irr=0;
% acc1.r=zeros(1,length(mat_trk.K_reduced));
% vel1.r=acc1.r;
% dis1.r=acc1.r;
% acc1.w=-9.8;
% vel1.w=-0.99;
% dis1.w=0;
% shape=acc1.r;
% shape(1,299)=1;
%nonlinear solver for vehicle track interaction within one time step using
%newmark integration and newton-raphson
function [acc2,vel2,dis2,F,Z,mc_ws2]=solver_newmark_iter(mat_trk,inp,shape, Z, wh_ld, acc1, vel1, dis1,mc_ws1,X_w_t, geo,Z_global,contactID,Fex, mat_ws,mat_vhcl, Y)
%initial condition
etol=1e-7;
deltat=inp.solver.deltat;
m_w=inp.mater(6).Data(2);
M_trk=mat_trk.M_reduced;
K_trk=mat_trk.K_reduced;
% current_ts=X_w_t;


if isfield(mat_trk,'C_reduced')==1
    C_trk=mat_trk.C_reduced;
else
    C_trk=sparse(zeros(length(mat_trk.K_reduced),length(mat_trk.K_reduced)));
end

%initial condition for iteration
ite=0;
penetration = Z.w-Z.r-Z.irr;

penetration(penetration>0)=0;


switch contactID
    case 5
        %non-linear
        F = inp.mater(contactID).Data.*(abs(penetration).^1.5);
    case 10
        %linear
        
        F = inp.mater(contactID).Data.*abs(penetration);
    case 111
        %Kik_Piot
        F = 0;
end


while 1
    
    F0=F;
    
    %for track system: newmark integration
    R_trk =-(F-Fex)*shape;
    [dis2.r, vel2.r,acc2.r]=newmark_sub(K_trk,M_trk,C_trk,R_trk,dis1.r,vel1.r, acc1.r, deltat);
    Z.r=(shape*dis2.r')'; %modification needed
    
    %for vehicle system
    if isempty(mat_ws)% mass wheelset model
        %     Fsum=sum(F);
        for i=1:2
            acc2.w(i)=(-m_w*9.8-wh_ld+F(i))/(m_w);
            vel2.w(i)=vel1.w(i)+deltat/2*(acc1.w(i)+acc2.w(i));
            dis2.w(i)=dis1.w(i)+deltat/2*(vel1.w(i)+vel2.w(i));
        end
        Z.w=dis2.w;
        mc_ws2=0;
    else % flexible wheelset using state-space model
        tspan=[0 deltat];%integral time span
        Fvector=(-m_w*9.8-wh_ld+F(1))/size(mat_ws.B,2).*ones(size(mat_ws.B,2),1);%input force vector
        [~,z] = ode45(@(t,z) ansys2modal(t,z,mat_ws.A,mat_ws.B,Fvector,0), tspan, mc_ws1);
        mc_ws2=z(end,:)';
        w=mat_ws.C*mc_ws2+mat_ws.D*Fvector;
        dis2.w=w(1,1)+Z_global.w(1,1);
        vel2.w=w(2,1);
        acc2.w=w(3,1);
        Z.w=dis2.w;
    end
    
    %update the contact force
    switch contactID
        %-----Hertz spring----
        case 5
            
            %nonlinear
            penetration = Z.w-Z.r-Z.irr;
            penetration(penetration>0)=0;
            
            
            F = inp.mater(contactID).Data*(abs(penetration).^1.5);
%         case 10
%             %linear
%             penetration = Z.w-Z.r-Z.irr;
%             penetration(penetration>0)=0;
%             F = inp.mater(contactID).Data.*abs(penetration);
%             %
        case 10
            %------Winkler bedding----
            F=winkler_bedding(6, X_w_t, dis2.r,dis2.w,Z_global.irr, geo, mat_trk,inp,-1);
            % BUG: "6" in the previous line should be replaced with the
            % initial position of the wheel X_w0
        %-----Kik_Piot----    
        case 111
            %Kik_Piot
            [F,~,~]=Fz_kik(Z,Y);
            
            
    end
    
    ite=ite+1;
    %     scatter(ite,F-F0);
    
    %check if the
    if length(F(abs(F-F0) <= etol))==2
%         disp(['Convergence reached in ', num2str(ite), ' iterations'])
        break
    end
    
    
    
    if ite>=100
        display(['Convergence not reached within 100 iterations.Out of balance force is ', num2str(F-F0)])
        break
    end
end


%% ========================= Calculating Nz in Iterations ================
function [N_tot,ai,lambda]=Fz_kik(ho)
%% ============================== INPUT DATA =============================
% fn=strin.fn;         % Normal force [N]
% 
% posw=strin.posw;       % contact position on wheel
% posr=strin.posr;
% 
% nux=strin.nux;        % x-creep
% nuy=strin.nuy;        % y-creep
% spin=strin.spin;       % spin [1/m]

mu=0.3;         % Coefficient of friction
ro=0.46;        % Wheel radius [m]

G=inp.mater(1).Data(5);         % Shear modulus [Pa]
ny=0.28;        % Poissons ratio

E=G*2*(1+ny);        % Modulus of elasticity [Pa]

kappa=0.55;          % penetration fraction
comp=1;              % shape correction

dx=0.0002;           % x-patrition  [m]
dy=0.0002;           % y-partition  [m]
dyr0=0.002;          % Initial radius for curvature evaluation

%% ================ READ WHEEL AND RAIL PROFILES =========================
A=load('UIC60_for_contactmethod.rpr');
 
yr=A(:,1);
zr=A(:,2);


A=load('s1002_for_contactmethod.wpr');

yw=A(:,1);
zw=A(:,2);

yaw=0;

%% ================ SEPARATION FUNC. & CONTACT POINT =====================
% Rigid vertical separation and contact point

yr=yr-posr;
yw=yw-posw;
ye=[min(yr):dy:max(yr)]';
zre=interp1(yr,zr,ye,'pchip');
zwe=interp1(yw,zw,ye,'pchip');
ne=length(ye);
dz=zwe-zre;
dz=dz-min(dz);
gam_r=atan(diff(zre)./diff(ye)); gam_r=[gam_r; gam_r(length(gam_r))];
gam_w=atan(diff(zwe)./diff(ye)); gam_w=[gam_w; gam_w(length(gam_w))];
gam=(gam_r+gam_w)/2;
gamo_r=interp1(ye,gam_r,0);
gamo_w=interp1(ye,gam_w,0);
gamo=(gamo_r+gamo_w)/2;

%%
        h=kappa*ho/cos(gamo);
        g=(h-dz).*cos(gam);
        %=================== Contact Patch Determination
        index(ne)=0; yc(ne)=0;  ai(ne)=0;
        k=1;
        for ii=1:ne
            if g(ii)>0             %strip in contact
                index(k)=ii;
                ai(k)=sqrt(2*ro*g(ii));
                yc(k)=ye(ii);
                k=k+1;
            end
        end
        index(k:end)=[];  yc(k:end)=[];  ai(k:end)=[];
        %=========================== Contact Patch Correction
        W=max(yc)-min(yc);
        L=2*max(ai);
        if k>1
            if comp
                if W/L <= 1
                    beta=1/(0.5837*(W/L)^2-0.1053*(W/L)^4+0.5184*(W/L));
                else
                    beta=(0.5837*(L/W)^2-0.1053*(L/W)^4+0.5184*(L/W));
                end
                Wc=sqrt(L*W/beta); dW=Wc-W;
                Lc=sqrt(L*W*beta);
                
                roo=(Lc)^2/8/h;
                yec=ye-dW/W*(ye);
                
                dzc=interp1(ye,dz,yec);
                g=h-dzc;
                
                index(ne)=0; yc(ne)=0;  ai(ne)=0;
                k=1;
                for ii=1:ne
                    if g(ii)>0             %strip in contact
                        index(k)=ii;
                        ai(k)=sqrt(2*roo*g(ii));
                        yc(k)=yec(ii);
                        k=k+1;
                    end
                end
                index(k:end)=[];  yc(k:end)=[];  ai(k:end)=[];
                lambda=Lc/Wc;
            else
                lambda=L/W;
            end
            %================== Normal Force Calculation
            xa=dx+max(ai);
            n_x=round(2*xa/dx);
            
            int1=0; int2=0;
            for ii=1:length(index)   % y integral
                % Starting point
                x=xa-dx/2;
                for jj=1:n_x         % x integral
                    if abs(x) < ai(ii)
                        int1=int1+sqrt(ai(ii)^2-x^2)*dx*dy;
                        int2=int2+sqrt(ai(ii)^2-x^2)/sqrt(x^2+yc(ii)^2)*dx*dy;
                    end % strip switch
                    x=x-dx;
                end        % x integral
            end            % y integral
            N_tot=pi*E*ho/2/(1-ny^2)*int1/int2;
        else
            N_tot=0;
            lambda=0;
            ai=0;
            int1=1;
        end
        
        if ~isfinite(N_tot)
            N_tot=0;
            lambda=0;
            ai=0;
        end
end
end
