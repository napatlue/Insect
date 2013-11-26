function [ dist ] = peak_distance( timeserie )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    sorted = sort(abs(timeserie(1,:)),'descend');
    max = sorted(1,1);
    min = sorted(1,100);
   
    step = 100;
    
    %find peaks  
    j = 1;
    for i=1:size(timeserie,2)-3
        left = timeserie(1,i);
        middle = timeserie(1,i+1);
        right = timeserie(1,i+2);
        
        if middle >=min && middle<=max
            if left<middle && middle>right  
               res(j,1) = i+1;
               res(j,2) = middle;   
               j = j+1;
            end
        end
       
    end
     
    dist = 0;
    sorted_res = sortrows(res,-2)
    old_dis = sorted_res(1,1);
    
    for i=2:size(sorted_res,1)
        
        new_dis = abs(sorted_res(i,1) - old_dis);
        
        if new_dis > step           
            dist = new_dis;
            break
        end
        
    end
    
end

