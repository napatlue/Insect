function [ timeseries ] = filter_timeserie( timeseries )
    
%   reduce dimension
    zero_cols = zeros(1,1);
    for i=1:size(timeseries,2)
        iszero = true;
        for j=1:size(timeseries,1)
            if timeseries(j,i) ~= 0
                iszero = false;
                break
            end
        end
        if iszero            
            zero_cols = [zero_cols i];
        end
    end
    size(zero_cols)
    
    for j=1:size(zero_cols,2)
         idx = zero_cols(1,j);
            
         timeseries(:,idx) = [];
           
    end
      
end

