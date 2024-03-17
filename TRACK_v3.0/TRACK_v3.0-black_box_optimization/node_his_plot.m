NodesHs=1501:10:1561;
if length(geo.ND)==6885
NodesHs=[NodesHs,6219:1:6236,6885];
else
    NodesHs=[NodesHs,3122:1:3131];
end

% th1=time_history(NodesHs,dis.r,vel.r,acc.r);
if isstruct(dis)==0
[dis_out,vel_out,acc_out]=time_history(NodesHs,dis,vel,acc, mat_trk.activeDof);
else
    [dis_out,vel_out,acc_out]=time_history(NodesHs,dis.r,vel.r,acc.r, mat_trk.activeDof);
acc_w=acc.w;
vel_w=vel.w;
dis_w=dis.w;
end






clear acc vel dis
% figure;
% [pxx,fxx]=periodogram(acc_out,hamming(length(acc_out)),length(acc_out),25600);
% plot(fxx,pxx(:,1:4));
% xlim([0,1500]);
% figure;
% plot(fxx,pxx(:,8:12));
% xlim([0,1500]);