function [ res ] = fft_raw( timeseries )
%doing fourier transform
    [rc,cc] = size(timeseries);
    res = zeros(rc+1,cc);
    
    for i=1:rc
        t = fft(timeseries(i,:));
        t = abs(t);
        res(i,:) = t;
    end
     
end

