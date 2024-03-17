load('measdata_full.mat')
bsm = length(time_m);
dt = mean(diff(time_m));
fsm = 1/dt;
data1 = squeeze(data_c(2:8,:,1)).';
time = [0:dt:(7*701-1)*dt];

%%
sig.val = reshape(data1,7*701,1);
sig.period = dt;

% scales.s0 = 2*dt; % Shortest scale (highest freq), at least twice the time step
% scales.ds = .5;   % resoluton, or steps
% scales.nb = 50;   % max number of scales
% scales.type = 'pow';% scale spacing
% scales.pow = 2;   %
scales = struct('s0',2*dt,'ds',.5,'nb',20,'type','pow','pow',2); % Alternatively

%cwtstruct = cwtft(sig,'scales',scales,'wavelet','morl');
cwtstruct = cwtft(sig,'scales',scales,'wavelet','morl','plot'); % Alternatively
fourierscale = 4*pi/(6+sqrt(2+6^2)); % Approx 1.033 for morlet with wavenumber 6
freqs = 1./(cwtstruct.scales*fourierscale);

figure(100)
contourf(time,freqs,abs(cwtstruct.cfs).^2)
set(gca,'YScale','log')

%% Reproduce signal 
cwtstruct2 = cwtstruct;
cwtstruct2.cfs = zeros(size(cwtstruct2.cfs));
cwtstruct2.cfs(10:14,:) = cwtstruct.cfs(10:14,:);

% xrec = icwtft(cwtstruct2);
xrec = icwtft(cwtstruct2,'signal',sig,'plot');  %Alternatively

figure(101)
plot(time,sig.val,time,xrec)