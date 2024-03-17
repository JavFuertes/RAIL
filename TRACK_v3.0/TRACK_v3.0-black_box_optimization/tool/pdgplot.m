[Pxx,F]=periodogram(acc,hamming(length(acc)),8192,sf);
% figure
% plot(F,Pxx);