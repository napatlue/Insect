function [result,ori] = preProcessWave(data)
%Preprocessing the wave
    % Get level 1 approximation using wavelet
    for i = 1:size(data ,1)
       [a1,d1] = dwt(data(i,:),'db12');
       datax(i,:) = a1;
         
    end

    ori = zeros(size(data,1),4500);

    result =zeros(size(datax,1),floor(size(datax,2)/2)-1);
    for i=1:size(datax,1)
        
        minHeight = max(data(i,:))/3;
        
        % Shift time series
        [pks,locs] = findpeaks((data(i,:)),'MINPEAKHEIGHT',minHeight, 'NPEAKS',1,'minpeakdistance',3);
        oo = circshift(data(i,:),[0 -(locs(1)-1500)]);
        ori(i,:) = oo(1:4500);
        % Do fft
        tmp = abs(fft(datax(i,:)));
        result(i,:) = tmp(2:floor(end/2)); %ignore f0
        
    end
    
end

