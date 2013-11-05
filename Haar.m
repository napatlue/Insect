function a_top20 = Haar(t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
w = 'db12'; 
a = t;
a = (a-mean(a))/std(a); % z-normalization
maxlevels = wmaxlev(length(a),w);
[Ca, La] = wavedec(a,maxlevels,w);
% Plot coefficients and MRA
%for level = 1:maxlevels
%cla;
%subplot(2,1,1);
%plot(detcoef(Ca,La,level)); axis tight;
%title(sprintf('Wavelet coefficients ? Level %d',level));
%subplot(2,1,2);
%plot(wrcoef('d',Ca,La,'haar',level)); axis tight;
%title(sprintf('MRA ? Level %d',level));
%pause;
%end
% Top-20 coefficient reconstruction
[Ca_sorted, Ca_sortind] = sort(Ca);
Ca_top20 = Ca; Ca_top20(Ca_sortind(1:end-19)) = 0;
a_top20 = waverec(Ca_top20,La,w);
%figure; hold on;
%plot(a, 'b'); plot(a_top20, 'r');


end

