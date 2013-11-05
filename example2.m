function example2(t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Set sampling period and wavelet name.
delta = 0.1; wname = 'coif3';

% Define scales. 
amax = 7;
a = t;

% Compute associated pseudo-frequencies.
f = scal2frq(a,wname,delta); 

% Compute associated pseudo-periods.
per = 1./f; 

% Plot pseudo-periods versus scales.
subplot(211), plot(a,per)
title(['Wavelet: ',wname, ', Sampling period: ',num2str(delta)])
xlabel('Scale')
ylabel('Computed pseudo-period')

% For each scale 2^i:
% - generate a sine function of period per(i);
% - perform a wavelet decomposition;
% - identify the highest energy level;
% - compute the detected pseudo-period.

for i = 1:amax
   % Generate sine function of period
   % per(i) at sampling period delta.
   t = 0:delta:100;
   x = sin((t.*2*pi)/per(i));
   % Decompose x at level 9.
   [c,l] = wavedec(x,9,wname);

   % Estimate standard deviation of detail coefficients.
   stdc = wnoisest(c,l,[1:amax]);
   % Compute identified period.
   [y,jmax] = max(stdc);
   idper(i) = per(jmax);
end

% Compare the detected and computed pseudo-periods.
subplot(212), plot(per,idper,'o',per,per)
title('Detected vs computed pseudo-period')
xlabel('Computed pseudo-period')
ylabel('Detected pseudo-period') 

end

