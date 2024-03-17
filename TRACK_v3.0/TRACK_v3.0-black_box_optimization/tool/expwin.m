function w = expwin(N, beta, p, normwin)

% EXPWIN Symmetric exponential window
%    EXPWIN(N,BETA,P,NORMWIN) returns a symmetric N point exponential
%    window with shaping parameter BETA.  P defines the power of the
%    exponential window.  When P = 1 (default), a regular exponential
%    window is obtained.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    Given an ALPHA parameterization, the equivalent BETA is
%       BETA = pi*ALPHA
%
%    See also EXPWORD, EXPORD.
%
%    Ref:
%    Exponential Window Family
%    K. Avci and A. Nacaroglu
%    Signal & Image Processing: An International Journal (SIPIJ)
%    Vol. 4, No. 4, August 2013

%  Joe Henning - Dec 2013
        
if nargin < 2
   fprintf('??? Bad beta input to expwin ==> beta must be specified\n');
   w = [];
   return;
end

if nargin < 3
   p = 1;
end

if nargin < 4
   normwin = 1;
end

if (N == 1)
   w = 1;
   return
end

M = (N-1)/2;

w = [];
for k = 0:M
   n = k-M;
   w(k+1) = exp(beta*sqrt(1-4*n*n/(N-1)/(N-1)))/exp(beta);
   w(N-k) = w(k+1);
end

% apply power
w = w(:).^p;

if (normwin)
   % normalize
   w = w/max(w);
end