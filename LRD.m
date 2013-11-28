function [ lof] = LRD( timeseries, k )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
    D = pdist(timeseries,'euclidean');
    Dm = squareform(D);
    
    for i=1:size(Dm,1)
        unique_val = unique(Dm(i,:));
        unique_val(:,1) = [];
        
        fts = unique_val(1,1:k);
        
        ct = 0;
        n = 1;
        for j=1:size(Dm,2)
            if i~=j
                if fts(fts == Dm(i,j))
                    k_nn(i,n) = j;
                    n = n+1;
                    ct = ct+1;
                end
            end
        end
       
        N_(i,1) = ct;
        N_(i,2) = fts(1,k); %fts: k-distance of i
        %find k-distance of timeseries in k_nn   
    end
    
    for i=1:size(k_nn,1) % calculate LRD for each timeserie
        %reachablity of k_nn(i)
        reacha = 0;
        for j=1:size(k_nn,2)
            pos = k_nn(i,j);
            reacha = reacha + max(Dm(i,pos), N_(pos,2));
        end
        lrd(i,1) = 1/(reacha/N_(i,1));
    end
    
    for i=1:size(k_nn,1)
        s = 0;
        for j=1:size(k_nn,2)
            s  = s + lrd(j,1);
        end
        lof(i,1) = (s/j)/lrd(i,1);
    end
    
    
end

