function [ pks,locs,dist12,dist23] = getpeaks(ts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dist23 = 0;
    dist12 = 0;
    mm = max(ts);
    [pks,locs] = findpeaks(ts,'MINPEAKHEIGHT',mm/20,'MINPEAKDISTANCE',50,'SORTSTR','descend');
    %[pks,locs] = findpeaks(ts,'MINPEAKHEIGHT',5,'MINPEAKDISTANCE',50);
    if(size(locs,2)>=2)
        dist12 = abs(locs(1)-locs(2));
    end
    %dist23 = abs(locs(2)-locs(3));
    
end

