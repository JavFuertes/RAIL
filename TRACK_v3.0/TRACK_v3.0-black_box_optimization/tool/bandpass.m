function [acc_f]=bandpass(acc, sf, f1, f2)

n = 2; Wn = [f1 f2]/(sf/2);
ftype = 'bandpass';

% Transfer Function design
[b,a] = butter(n,Wn,ftype);


acc_f = filter(b,a,acc);