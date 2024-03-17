Fs = 25600;      % Sampling frequency
Tend = 1;   % Length of time vector
Timp = 0.4e-3;  % Impulse width
Fmax = -3.097e3;    % Impulse peak amplitude
ind = [1:round(Fs*Timp)];
Timp = ind(end)/Fs;
ind = ind+1;    % delay the impulse by number of samples
time = [0:1/Fs:Tend];
Fsim = zeros(size(time));
Fsim(ind) = .5*Fmax*(1-cos(2*pi/Timp*time(1:length(ind))));
figure(1)
plot(time,Fsim)
[time; Fsim].'
Fsim=Fsim';

