function [ stds, means ] = purify_mean( train_dist_set, iter_times )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
    tmp_m = grpstats(train_dist_set, train_dist_set(:,1));
    tmp_s = grpstats(train_dist_set, train_dist_set(:,1),'std');
    
    for i=2:size(tmp_s,1)
        stds(i-1,1) = i-1;
        stds(i-1,2) = tmp_s(i,2);
        means(i-1,1) = i-1;
        means(i-1,2) = tmp_m(i,2);
    end
  for ct=1:iter_times
    i = size(train_dist_set,1);
    while i > 0
   
        class_L = train_dist_set(i,1);
        if class_L == 0
            train_dist_set(i,:) = [];
            i = i-2;
            continue;
        end
        if abs(train_dist_set(i,2)-stds(class_L,2)) > means(class_L,2)
            train_dist_set(i,:) = [];
            i = i-2; 
        end
        i = i-1;
    end
    tmp_m = grpstats(train_dist_set, train_dist_set(:,1));
    tmp_s = grpstats(train_dist_set, train_dist_set(:,1),'std');
    
    for i=2:size(tmp_s,1)
        stds(i-1,1) = i-1;
        stds(i-1,2) = tmp_s(i,2);
        means(i-1,1) = i-1;
        means(i-1,2) = tmp_m(i,2);
    end
    
  end
end

