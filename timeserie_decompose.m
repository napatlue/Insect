function [ Aj_1,Dj_1 ] = timeserie_decompose( serie )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    total_count = size(serie,2);
    Aj_1 = zeros(1,round(total_count/2));
    Dj_1 = zeros(1,round(total_count/2));
    j = log2(size(serie,2));
    J = ceil(j);
    total_count = power(2, J);
    %padding with 0, total count has to be power of 2
    serie(:,total_count) = 0; 
        
    
    i = 1;
    j = 1;
   
    while(i <= total_count)
        Aj_1(1,j) = (serie(:,i)+serie(:,i+1))/sqrt(2);
        Dj_1(1,j) = (serie(:,i)-serie(:,i+1))/sqrt(2);
        i = i+2;
        j = j+1;
    end
end

