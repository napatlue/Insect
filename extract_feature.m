function [ curr_features ] = extract_feature( series )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    j = log2(size(series,2));
    J = ceil(j);
    %last_features = zeros(size(series,1),:);
    %last_dss = zeros(size(series, 1),:);
    sum_last_ene = 0;
    for i=1:size(series,1)
        t = series(i,:);
        [AJ_1, DJ_1] = timeserie_decompose(t);
        last_features(i,:) = AJ_1;
        last_dss(i,:) = DJ_1;
        sum_last_ene = sum_last_ene + energy(DJ_1);
    end
    
    %energy_DJ_1 = energy(DJ_1);
    exit_f = true;
    
    j=J-2;
    sum_ene = 0;
    while(j>0)
        for i=1:size(series,1)
            [curr_features(i,:), curr_dss(i,:)] = timeserie_decompose(last_features(i,:));
            sum_ene = sum_ene + energy(curr_dss(i,:));
        end
        if sum_ene > sum_last_ene
            k = j
            %while(k>0)
            %    curr_features(k, :) = [];
            %    k = k-1;
            %end
            exit_f = false;
            break
        end

        j = j-1;
        last_features = curr_features;
        
        sum_last_ene = 0;
        for k=1:size(curr_dss,1)
            sum_last_ene = sum_last_ene + energy(curr_dss(k, :));
        end
    end
    
        
   
end

