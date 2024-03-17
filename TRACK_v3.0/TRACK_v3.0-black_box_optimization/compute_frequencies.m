function [freqs,modes] = compute_frequencies(k1,k2,k3,m1,m2)
 
M = [m1,0;0,m2];
K = [k1+k2,-k2;-k2,k2+k3];
[V,D] = eig(K,M);
for i = 1:2
    freqs(i) = sqrt(D(i,i));
end
modes = V;
 
end