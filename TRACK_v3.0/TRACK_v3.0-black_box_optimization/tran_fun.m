function [H1,H2,Coh,pxx,pxy,fxx]=tran_fun(sig,window,overlap,nfft,sf)
% TRAN_FUN Caculates FRF and coherence of hammer test result
%     [H1,H2,Coh,pxx,pxy,fxx]=tran_fun(sig,window,overlap,nfft,sf) 
% 
%     Inputs
%     sig    is M*N matrix where the signals derived from hammer test
%     (single impact) are
%     store, with each colomn representing a channel and the first channel
%     representing the iput hammer force
%     window is the exponential window with the same lenght as the signal
%     overlap, nfft and sf are the same as in pwelch
% 
        


%exponential window

if window==1
    w=expwin(length(sig)*2,10);
w=w(length(sig)+1:end,1);
window=w;
% else
%     w=expwin(window*2,10);
% w=w(window+1:end,1);
end


[pxx,fxx]=pwelch(sig,window,overlap,nfft,sf);
pxy=cpsd(sig(:,1),sig(:,2:end),window,overlap,nfft,sf);

for i=1:size(sig,2)-1
    H1(:,i)=pxy(:,i)./pxx(:,1);
end
for i=1:size(sig,2)-1
    H2(:,i)=pxx(:,i+1)./pxy(:,i);
end

Coh=mscohere(sig(:,1),sig(:,2:end),window,overlap,nfft,sf);


end
