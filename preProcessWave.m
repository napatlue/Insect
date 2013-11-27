function result = preProcessWave(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    result =zeros(size(data,1),floor(size(data,2)/2)-1);
    for i=1:size(data,1)
        
        %minHeight = max(data(i,:))/3;
        
        
        %[pks,locs] = findpeaks((data(i,:)),'MINPEAKHEIGHT',minHeight, 'NPEAKS',1,'minpeakdistance',3);
        
        %tmp = circshift(data(i,:),[0 -(locs(1)-1500)]);
        tmp = abs(fft(data(i,:)));
        result(i,:) = tmp(2:floor(end/2)); %ignore f0
        
    end

end

