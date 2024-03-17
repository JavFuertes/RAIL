function [K,M]=mass_spring(k,m)
K=zeros(length(k),length(k));
M=zeros(length(m),length(m));
k=[k;0];
for i=1:length(k)-1
    K(i,i)=k(i)+k(i+1);
    M(i,i)=m(i);
end
for i=1:length(k)-2
    K(i,i+1)=-k(i+1);
    K(i+1,i)=-k(i+1);
end



    
    
  
end
