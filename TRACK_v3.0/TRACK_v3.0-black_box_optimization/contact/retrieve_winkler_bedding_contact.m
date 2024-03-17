a=2e-2;
dx=2e-4;
xq=-a:dx:a;
numTimeStep = 1000;
Fn = zeros(numTimeStep,2);
f = zeros(length(xq),numTimeStep);
for timeStep = 1:numTimeStep
    X_w_t = X_w(1,1)+timeStep*inp.solver.deltat*vx;
    [Fn(timeStep,:),f(:,timeStep)] = winkler_bedding(X_w(1,1), X_w_t, ...
        dis.r(timeStep,:),dis.w(timeStep,1),Z.irr, geo, mat_trk,inp,-1);
end