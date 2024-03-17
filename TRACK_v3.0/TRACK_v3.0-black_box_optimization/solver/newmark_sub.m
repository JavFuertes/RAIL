function [dis2, vel2,acc2]=newmark_sub(K,M,C,R,dis1,vel1, acc1, deltat, delta,alpha)
	% P781 in Finite Element Procedures by K.J. Bathe 1996
	%
if nargin <= 8
    
    delta=0.5;
    alpha=0.25;
end

a0=1/(alpha*deltat^2);
a1=delta/(alpha*deltat);
a2=1/(alpha*deltat);
a3=(1/(2*alpha))-1;
a4=(delta/alpha)-1;
a5=(deltat/2)*((delta/alpha)-2);
a6=deltat*(1-delta);
a7=delta*deltat;

K=K+a0*M+a1*C;
R = R' + M*(a0*dis1'+a2*vel1'+a3*acc1')+ C*(a1*dis1'+a4*vel1'+a5*acc1');

dis2=(K\R)';
acc2 = a0*(dis2-dis1) - a2*vel1 - a3*acc1;
vel2= vel1 + a6*acc1 + a7*acc2;
end
