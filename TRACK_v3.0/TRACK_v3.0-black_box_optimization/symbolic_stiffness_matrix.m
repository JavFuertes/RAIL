syms EI l ksi 
Be = [6*ksi (3*ksi-1)*l -6*ksi (3*ksi+1)*l]./(l^2);
Ke = EI*l/2*int(Be'*Be,ksi,[-1 1]);

syms t Jac L phi
NTiP(1,1) = (1-t)/2;
NTiP(2,1) = (1+t)/2;
NTiP(3,1) = 0; NTiP(4,1) = 0; NTiP(5,1) = 0; NTiP(6,1) = 0;
NTiP(1,2) = 0; NTiP(2,2) = 0;
NTiP(3,2) = 1/4/(1+phi)*(t-1)*(t^2+t-2*(1+phi));
NTiP(4,2) = 1/4/(1+phi)*(2*(t+1)*(1+phi)+t-t^3);
NTiP(5,2) = L/8/(1+phi)*((t^2-1)*(t-1-phi));
NTiP(6,2) = L/8/(1+phi)*((t^2-1)*(t+1+phi));
NTiP(1,3) = 0; NTiP(2,3) = 0;
NTiP(3,3) = 3/2/L/(1+phi)*(t^2-1);
NTiP(4,3) = 3/2/L/(1+phi)*(-t^2+1);
NTiP(5,3) = 1/4/(1+phi)*((t-1)*(3*t+1-2*phi));
NTiP(6,3) = 1/4/(1+phi)*((t+1)*(3*t-1+2*phi));