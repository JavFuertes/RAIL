function w = flatwin(n,window)

% FLATWIN Symmetric Flat-Top window
%    FLATWIN(N,WIN) returns a symmetric N point Flat-Top window by
%    evaluating the first half and then flipping the same samples over
%    the other half.
%
%    WIN specifies the window type:
%       0 : SFT3F, 31.7 dB, differentiable, 0.0082 dB flatness
%       1 : SFT4F, 44.7 dB, 2nd differentiable, 0.0041 dB flatness
%       2 : SFT5F, 57.3 dB, 3rd differentiable, -0.0025 dB flatness
%       3 : SFT3M, 44.2 dB, -0.0115 dB flatness
%       4 : SFT4M, 66.5 dB, -0.0067 dB flatness
%       5 : SFT5M, 89.9 dB, 0.0039 dB flatness
%       6 : FTNI (National Instruments), 44.4 dB, 0.0169 dB flatness
%       7 : FTHP (old Hewlett Packard), 70.4 dB, 0.0096 dB flatness
%       8 : FTSRS (Stanford Research SR785), 76.6 dB, differentiable, -0.0156 dB flatness
%       9 : Matlab, 93.0 dB, 0.0097 dB flatness
%      10 : HFT70 (3-term cosine), 70.4 dB, -0.0065 dB flatness
%      11 : HFT95 (4-term cosine), 95.0 dB, 0.0044 dB flatness
%      12 : HFT90D (4-term cosine), 90.2 dB, differentiable, -0.0039 dB flatness
%      13 : HFT116D (5-term cosine), 116.8 dB, differentiable, -0.0028 dB flatness
%      14 : HFT144D (6-term cosine), 144.1 dB, differentiable, 0.0021 dB flatness
%      15 : HFT169D (7-term cosine), 169.5 dB, differentiable, 0.0017 dB flatness
%      16 : HFT196D (8-term cosine), 196.2 dB, differentiable, 0.0013 dB flatness
%      17 : HFT223D (9-term cosine), 223.0 dB, differentiable, -0.0011 dB flatness
%      18 : HFT248D (10-term cosine), 248.4 dB, differentiable, 0.0009 dB flatness
%    In the above, "F" indicates "fast decaying" which enforces a high
%    degree of differentiability, "M" indicates minimum sidelobe, and
%    "HFT" indicates the window with lowest sidelobe level.
%
%    See also FLATTOPWIN.
%
%    Ref:
%    Spectrum and spectral density estimation by the Discrete Fourier transform (DFT), including a comprehensive list of window functions and some new flat-top windows
%    G. Heinzel, A. Rudiger, and R. Schilling
%    Max-Planck-Institut fur Gravitationsphysik
%    (Albert-Einstein-Institut)
%    Teilinstitut Hannover
%    February 15, 2002

%  Joe Henning - 6 May 2013

if nargin < 2
   window = 1;
end

if ~rem(n,2)
   % Even length window
   half = n/2;
   w = calc_window(half,n,window);
   w = [w; w(end:-1:1)];
else
   % Odd length window
   half = (n+1)/2;
   w = calc_window(half,n,window);
   w = [w; w(end-1:-1:1)];
end

% normalize
w = w(:)/max(w);


function w = calc_window(m,n,window)
% CALC_WINDOW Calculate the window samples
%    CALC_WINDOW calculates and returns the first M points of an
%    N point window determined by the window number

x = (0:m-1)'/(n-1);

switch window
   case 0
      % SFT3F, differentiable, -31.7 dB, NBW 3.1681 bins, 0.0082 dB, first zero at +/- 3 bins
      a0 = 0.26526;
      a1 = 0.5;
      a2 = 0.23474;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x);
   case 1
      % SFT4F, 2nd differentiable, -44.7 dB, NBW 3.7970 bins, 0.0041 dB, first zero at +/- 4 bins
      a0 = 0.21706;
      a1 = 0.42103;
      a2 = 0.28294;
      a3 = 0.07897;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x);
   case 2
      % SFT5F, 3rd differentiable, -57.3 dB, NBW 4.3412 bins, -0.0025 dB, first zero at +/- 5 bins
      a0 = 0.1881;
      a1 = 0.36923;
      a2 = 0.28702;
      a3 = 0.13077;
      a4 = 0.02488;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x);
   case 3
      % SFT3M, -44.2 dB, NBW 2.9452 bins, -0.0115 dB, first zero at +/- 3 bins
      a0 = 0.28235;
      a1 = 0.52105;
      a2 = 0.19659;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x);
   case 4
      % SFT4M, -66.5 dB, NBW 3.3868 bins, -0.0067 dB, first zero at +/- 4 bins
      a0 = 0.241906;
      a1 = 0.460841;
      a2 = 0.255381;
      a3 = 0.041872;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x);
   case 5
      % SFT5M, -89.9 dB, NBW 3.8852 bins, 0.0039 dB, first zero at +/- 5 bins
      a0 = 0.209671;
      a1 = 0.407331;
      a2 = 0.281225;
      a3 = 0.092669;
      a4 = 0.0091036;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x);
   case 6
      % FTNI (National Instruments), -44.4 dB, NBW 2.9656 bins, 0.0169 dB, first zero at +/- 3 bins
      a0 = 0.2810639;
      a1 = 0.5208972; 
      a2 = 0.1980399;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x);
   case 7
      % FTHP (old Hewlett Packard), -70.4 dB, NBW 3.4279 bins, 0.0096 dB, first zero at +/- 4 bins
      a0 = 	1.0;
      a1 = 1.912510941;
      a2 = 1.079173272;
      a3 = 0.1832630879;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x);
   case 8
      % FTSRS (Stanford Research SR785), differentiable, -76.6 dB, NBW 3.7702 bins, -0.0156 dB, first zero at +/- 4.72 bins
      a0 = 1.0;
      a1 = 1.93;
      a2 = 1.29;
      a3 = 0.388;
      a4 = 0.028;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x);
   case 9
      % Matlab, -93.0 dB, NBW 3.774 bins, 0.0025 dB, first zero at +/- 5.01 bins
      a0 = 0.21557895;
      a1 = 0.41663158;
      a2 = 0.277263158;
      a3 = 0.083578947;
      a4 = 0.006947368;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x);
   case 10
      % HFT70 (lowest sidelobe level with 3 cosine terms), -70.4 dB, NBW 3.4129 bins, -0.0065 dB, first zero at +/- 4 bins
      a0 = 1.0;
      a1 = 1.90796;
      a2 = 1.07349;
      a3 = 0.18199;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x);
   case 11
      % HFT95 (lowest sidelobe level with 4 cosine terms), -95.0 dB, NBW 3.8112 bins, 0.0044 dB, first zero at +/- 5 bins
      a0 = 1.0;
      a1 = 1.9383379;
      a2 = 1.3045202;
      a3 = 0.4028270;
      a4 = 0.0350665;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x);
   case 12
      % HFT90D (lowest sidelobe level with 4 cosine terms), differentiable, -90.2, NBW 3.8832 bins, -0.0039 dB, first zero at +/- 5 bins
      a0 = 1.0;
      a1 = 1.942604;
      a2 = 1.340318;
      a3 = 0.440811;
      a4 = 0.043097;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x);
   case 13
      % HFT116D (lowest sidelobe level with 5 cosine terms), differentiable, -116.8 dB, NBW 4.2186 bins, -0.0028 dB, first zero at +/- 6 bins
      a0 = 1.0;
      a1 = 1.9575375;
      a2 = 1.4780705;
      a3 = 0.6367431;
      a4 = 0.1228389;
      a5 = 0.0066288;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x) - a5*cos(10*pi*x);
   case 14
      % HFT144D (lowest sidelobe level with 6 cosine terms), differentiable, -144.1 dB, NBW 4.5386 bins, 0.0021 dB, first zero at +/- 7 bins
      a0 = 1.0;
      a1 = 1.96760033;
      a2 = 1.57983607;
      a3 = 0.81123644;
      a4 = 0.22583558;
      a5 = 0.02773848;
      a6 = 0.00090360;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x) - a5*cos(10*pi*x) + a6*cos(12*pi*x);
   case 15
      % HFT169D (lowest sidelobe level with 7 cosine terms), differentiable, -169.5 dB, NBW 4.8347 bins, 0.0017 dB, first zero at +/- 8 bins
      a0 = 1.0;
      a1 = 1.97441842;
      a2 = 1.65409888;
      a3 = 0.95788186;
      a4 = 0.33673420;
      a5 = 0.06364621;
      a6 = 0.00521942;
      a7 = 0.00010599;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x) - a5*cos(10*pi*x) + a6*cos(12*pi*x) - a7*cos(14*pi*x);
   case 16
      % HFT196D (lowest sidelobe level with 8 cosine terms), differentiable, -196.2 dB, NBW 5.1134 bins, 0.0013 dB, first zero at +/- 9 bins
      a0 = 1.0;
      a1 = 1.979280420;
      a2 = 1.710288951;
      a3 = 1.081629853;
      a4 = 0.448734314;
      a5 = 0.112376628;
      a6 = 0.015122992;
      a7 = 0.000871252;
      a8 = 0.000011896;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x) - a5*cos(10*pi*x) + a6*cos(12*pi*x) - a7*cos(14*pi*x) + a8*cos(16*pi*x);
   case 17
      % HFT223D (lowest sidelobe level with 9 cosine terms), differentiable, -223.0 dB, NBW 5.3888 bins, -0.0011 dB, first zero at +/- 10 bins
      a0 = 1.0;
      a1 = 1.98298997309;
      a2 = 1.75556083063;
      a3 = 1.19037717712;
      a4 = 0.56155440797;
      a5 = 0.17296769663;
      a6 = 0.03233247087;
      a7 = 0.00324954578;
      a8 = 0.00013801040;
      a9 = 0.00000132725;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x) - a5*cos(10*pi*x) + a6*cos(12*pi*x) - a7*cos(14*pi*x) + a8*cos(16*pi*x) - a9*cos(18*pi*x)
   case 18
      % HFT248D (lowest sidelobe level with 10 cosine terms), differentiable, -248.4 dB, NBW 5.6512 bins, 0.0009 dB, first zero at +/- 11 bins
      a0 = 1.0;
      a1 = 1.985844164102;
      a2 = 1.791176438506;
      a3 = 1.282075284005;
      a4 = 0.667777530266;
      a5 = 0.240160796576;
      a6 = 0.056656381764;
      a7 = 0.008134974479;
      a8 = 0.000624544650;
      a9 = 0.000019808998;
      a10 = 0.000000132974;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x) + a4*cos(8*pi*x) - a5*cos(10*pi*x) + a6*cos(12*pi*x) - a7*cos(14*pi*x) + a8*cos(16*pi*x) - a9*cos(18*pi*x) + a10*cos(20*pi*x);
   otherwise
      error('Unknown WIN type');
end