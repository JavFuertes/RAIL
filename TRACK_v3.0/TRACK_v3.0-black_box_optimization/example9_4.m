clear;

delta=0.5;
alpha=0.25;
deltat=0.28;

a0=1/(alpha*deltat^2);
a1=delta/(alpha*deltat);
a2=1/(alpha*deltat);
a3=(1/(2*alpha))-1;
a4=(delta/alpha)-1;
a5=(deltat/2)*((delta/alpha)-2);
a6=deltat*(1-delta);
a7=delta*deltat;

K=[6 -2; -2 4];
M=[2 0; 0 1];


K=K+a0*M;

dis = zeros(20,2);
vel = zeros(20,2);
acc = zeros(20,2);
acc(1,:)= [0,10];

for i=1:20
    R=[0;10];
    
    R = R + M*(a0*dis(i,:)'+a2*vel(i,:)'+a3*acc(i,:)');
    
    
    dis(i+1,:)=(K\R)';


    acc(i+1,:) = a0*(dis(i+1,:)-dis(i,:)) - a2*vel(i,:) - a3*acc(i,:);
    vel(i+1,:) = vel(i,:) + a6*acc(i,:) + a7*acc(i+1,:);

end