function [hil,phi,dphi,freq,amp]=hilbert_transf(sig,sf)
hil=hilbert(sig);
phi=phase(hil);
dphi=diff(phi)./(1/sf);
freq=dphi./(2*pi());
freq=[mean(freq);freq];
amp=abs(hil);

end