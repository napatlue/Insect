function [ res ] = fft_raw( timeseries )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    [rc,cc] = size(timeseries);
    res = zeros(rc+1,cc);
    
    for i=1:rc
        t = fft(timeseries(i,:));
        t = abs(t);
        res(i,:) = t;
    end
     
end

