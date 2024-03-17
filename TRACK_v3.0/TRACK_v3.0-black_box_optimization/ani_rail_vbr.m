figure;
% frame(51)
for i=550:600
    plot(geo.ND(1:6001,2),10*dis.r(i,1:2:12001));
    hold on
   
    plot(X_w(i),10*Z.r(i),'o','MarkerFaceColor','red');
    hold off
    frame(i-549)=getframe;
    
end
