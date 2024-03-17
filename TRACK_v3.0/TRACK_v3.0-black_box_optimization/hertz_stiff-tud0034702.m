function ch=hertz_stiff(rn,rw,rr,E1,v1,E2,v2)
A=1/(2*rn);
B=1/2*(1/rw+1/rr);

theta=180*acos((B-A)/(B+A))/pi;
rt=r(theta);
Ee=1/((1-v1^2)/E1+(1-v2^2)/E2);

ch=4/3*Ee*(1/sqrt(A+B))*(1/rt^1.5);

end
function f = r(teta)

% Parameter r(teta) for penetration delta in the Hertzian contact ellipse

taeta=[0.0 5.0 10.0 30.0 60.0 90.0 120.0 150.0 170.0 175.0 180.];

rtab=[0.0 0.2969 0.4280 0.7263 0.9376 1.0 0.9376 0.7263 0.4280 0.2969 0.0];

%figure,plot(taeta,rtab),title('r')

f=spline(taeta,rtab,teta);
end