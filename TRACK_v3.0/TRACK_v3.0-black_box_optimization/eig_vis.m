% K=round(mat_trk.K_reduced,-1);
%  M=round(mat_trk.M_reduced,15);
K=mat_trk.K_reduced;
M=mat_trk.M_reduced;
C=mat_trk.C_reduced;
nmode=800;


A=[C,M;M,zeros(length(M),length(M))];
B=[K,zeros(length(M),length(M));zeros(length(M),length(M)),-1*M];
[V,D]=eigs(-1*B,A,nmode,'smallestabs');
s=diag(D);
s1=s(1:2:end);
s2=s(2:2:end);
V1=V(1:length(M),1:2:end);
V2=V(1:length(M),2:2:end);
% for r=1:nmode/2
%     kr=V1(:,r)'*K*V2(:,r);
%     mr=V1(:,r)'*M*V2(:,r);
%     omega(r,1)=kr/mr;
% end
frqEigb=abs(s1)/(2*pi());
dr=-real(s1)./abs(s1);