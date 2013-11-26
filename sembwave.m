function [s,d]=sembwave(t,y1,y2,nscales,order)
% ****************************************************************
% *** Wavelet semblance analysis
% *** Requires Matlab wavelet toolbox
% *** Type sembwave; for demo with synthetic data
% *** GRJ Cooper 2003
% *** School of Geosciences, University of the Witwatersrand
% *** Johannesburg, South Africa
% *** cooperg@geosciences.wits.ac.za, grcooper@iafrica.com
% *** www.wits.ac.za/science/geophysics/gc.htm
% ****************************************************************
% *** Inputs;
% *** t         Time axis 
% *** y1,y2     Datasets to be compared
% *** nscales   No. of scales to use - not more than length(t)...
% *** order     Positive odd integers only - try 1 first
% ****************************************************************
% *** Outputs;
% *** s,d       Semblance and Dot product
% ****************************************************************

% demo analysis if program is run with no arguments

if nargin==0                        
 t=1:512;
 y1=sin(t*0.05)+sin(t*0.15);
 y2(1:170)=-sin(t(1:170)*0.05)+sin(t(1:170)*0.15);
 y2(171:340)=sin(t(171:340)*0.05)+cos(t(171:340)*0.15);
 y2(341:512)=cos(t(341:512)*0.05)-sin(t(341:512)*0.15);
 nscales=200;
 order=1;
end;

% Check the input data and prepare for wavelet analysis

y1(isnan(y1))=0; y2(isnan(y2))=0;  % Set NaN's to zero
m1=mean(y1(:)); m2=mean(y2(:)); y1=y1-m1; y2=y2-m2; % Remove the mean
nscales=round(abs(nscales));       % Check the user input a valid no. of scales


% Perform the wavelet transforms and compute the semblance

c1=cwt(y1,1:nscales,'cmor1-1'); 
c2=cwt(y2,1:nscales,'cmor1-1');    % Compute the CWT's
ctc=c1.*conj(c2); ct=abs(ctc);     % Cross wavelet transform amplitude
spt=atan2(imag(ctc),real(ctc));    % Cross wavelet phase
order=abs(order); order=floor(order/2)+1; % Check the user input a valid order
s=cos(spt); s=s.^order;            % Semblance
d=s.*ct;                           % Dot product

% Display results

figure(1);
currfig=get(0,'CurrentFigure'); set(currfig,'numbertitle','off');
set(currfig,'name','Wavelet Semblance Analysis'); 
y1=y1+m1; y2=y2+m2;
subplot(6,1,1); plot(t,y1); axis tight; title('Data 1');
subplot(6,1,2); imagesc(real(c1)); axis xy; axis tight; title('Data 1 CWT Real Part'); ylabel('Scale');
subplot(6,1,3); plot(t,y2); axis tight; title('Data 2'); 
subplot(6,1,4); imagesc(real(c2)); axis xy; axis tight; title('Data 2 CWT Real Part'); ylabel('Scale');
subplot(6,1,5); imagesc(s,[-1 1]); axis xy; axis tight; title('Semblance'); ylabel('Scale');
dmin=abs(min(d(:))); dmax=max(d(:)); ddmax=max([dmin dmax]);  % Make sure scaling is correct
subplot(6,1,6); imagesc(d,[-ddmax ddmax]); axis tight; axis xy; title('Dot Product'); ylabel('Scale');
colormap(jet(256));

end
