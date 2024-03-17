function [xx,yy,power,freq,wp,scale,coi]= wps_plot (x,sig,sf,plot)
% sf=25000;
% sig=acc_timo_trim(:,1);
mother = 'MORLET';
dt = 1/sf;

dj = 0.125; %0.125/4; %0.125  % resolution
s0 = 2*dt;
j1 = 14/dj;    % ch
sst = sig;%(acc - mean(acc))/std(acc) ;
%mother = 'PAUL'; 'Morlet'; 'DOG'
[wave,period,scale,coi] = wavelet(sst,dt,1,dj,s0,j1,mother);
% power = (abs(wave)).^2 ;
power = wave.* conj(wave);
% power = real (wave);
% power=wave;

%phase=atan(imag(wave)./real(wave));
%phase=asin(imag(wave)./sqrt(imag(wave).^2+real(wave).^2));
freq=1./period;


[xx,yy]=meshgrid(x,freq);
if nargin <4
    plot=0;
end

if plot==1
    % figure
    mesh(xx,yy,power);
    view(0,90);
end

wp=sum(power,2)./length(sig);
% wp_max=max(wp);
% wp_norm=wp/wp_max;
end


