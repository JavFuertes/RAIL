function [x_irr,z_irr] = sin_irr_def(initial, length, depth, deltat, vx, N_ts)
x_irr=0:deltat*vx:deltat*vx*N_ts;
z_irr=zeros(N_ts+1,1);

irr_depth=depth;
irr_length=length;
irr_x0=initial;

irr_ts0=round(irr_x0/vx/deltat);
irr_ts1=round((irr_x0+irr_length)/vx/deltat);

for i=irr_ts0:1:irr_ts1;
    
    z_irr(i,1)=irr_depth./2*(cos(2*pi./irr_length*(deltat*i*vx-irr_x0))-1);

end

end
