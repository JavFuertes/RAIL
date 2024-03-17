function [acc_f]=lowpass(n, acc, sf, f1)

 Wn = f1/(sf/2);

% Transfer Function design

        if Wn >0.001
             [b,a] = butter(n,Wn,'low');
       elseif Wn >0.00005
             [b,a] = ellip(n,2,90,Wn);
        else
             [b,a] = ellip(n,2,120,Wn);
        end


acc_f = filter(b,a,acc);