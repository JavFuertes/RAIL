m=[140;
   100;   
   60;
   800];%800;

k=[4.8458e7;
   1.3e8;
   1.3e9;
   8.7e7];%8.7e8


[K,M]=mass_spring(k,m);
[u,l]=eig(K,M);
%%
%-----------FREQUENCY RESPONSE FUNCTION-------
% omega=0:1:100;
omega=logspace(0,5,1000);

for i=1:length(K)
for j=1:length(omega)
omega_v(i,j)=1/(l(i,i)-(omega(1,j)^2));
end
end
for i=1:length(K)
phi_v(1,i)=u(3,i)*u(3,i);
end

alpha33=phi_v*omega_v;

figure;
plot(omega./(2*3.14),alpha33.^2);
%%
%---------
% The output from ?eig?gives unit-length eigenvectors.
% We need to scale them with respect to M.
%
for s=1:length(K)
alfa=sqrt(u(:,s)'*M*u(:,s));
u(:,s)=u(:,s)/alfa;
end
x0=[0;0;0;0]; 
xd0=[10;0;0;0]; 
tf=0.1;
t=0:1/25000:tf;
q=tf/(1/25000);
x=zeros(size(length(K),length(t)));
% Applying Equation 7.183.
%
for j=1:length(K)
w(j)=sqrt(l(j,j)); 
xt=u(:,j)*(u(:,j)'*M*x0*cos(w(j).*t)+u(:,j)'*M*xd0/w(j)*sin(w(j).*t));
x=x+xt;
end

for i=1:length(k)-1
pene(i,:)=x(i+1,:)-x(i,:);
    F(i,:)=k(i)*pene(i,:);
end
sf=25000;
NFFT=2560;
f_fft=sf/2*linspace(0,1,NFFT/2-1);
Y_fft_dis=fft(x',NFFT);

for i=1:length(k)-1
Y_fft_pene(:,i)=Y_fft_dis(:,i+1)-Y_fft_dis(:,i);
end

Y_fft_pene2=fft(pene',NFFT);
figure;
plot(f_fft,abs(Y_fft_pene(1:1279,3)));
hold on
plot(f_fft,abs(Y_fft_pene2(1:1279,3)));

