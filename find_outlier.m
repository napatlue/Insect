function [ outlier_name, outlier_dist ] = find_outlier( path,k )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here
    Anomalies_wav = dir([path, '*.wav']);
    length(Anomalies_wav)
    
    for i=1 : length(Anomalies_wav)
        org_filename = Anomalies_wav(i).name;
        
        converted_data_i = wavread([path, org_filename]);          
        ts(i,:) = converted_data_i;
    end
    res_from_lof = LRD(ts, k);
    c=1;
    [~,sort_indices] = sort(res_from_lof(:,1),'descend');
    for i=1:size(sort_indices,1)
        pos = sort_indices(i,1);
        dist = res_from_lof(pos,1);
        
        if dist > 1
            outlier_name(c,:) = Anomalies_wav(pos).name;
            outlier_dist(c,1) = dist; 
            outlier_pos(c,1) = pos;
            c = c+1;
            
        end
    end
    %figure('Name','anomaly detection');
    %for i=1:size(outlier_pos,1)
    %    a = subplot(size(outlier_pos,1),1,i);
    %    plot(ts(outlier_pos(i,1),:));
    %    title(a,outlier_name(i,:));
    %end
    %figure('Name','normal ones');
    
    %for i=1:size(outlier_pos,1)
    %    pp = outlier_pos(i,1)
    %    ts(outlier_pos(i,1),:) = [];
    %    Anomalies_wav(i) = [];
    %end
    %for j=1:size(outlier_pos,1)
    %    b = subplot(size(outlier_pos,1),1,j);
    %    plot(ts(j,:));
    %    title(b,Anomalies_wav(j).name);
    %end
    
    
end

