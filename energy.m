function [ ene ] = energy( serie )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    ene = 0;
    for i=1:size(serie,2)
        ene = ene + serie(1,i)^2; 
    end

end

