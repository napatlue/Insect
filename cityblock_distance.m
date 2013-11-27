function result = cityblock_distance( obj1,obj2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    tmp = abs(obj1-obj2);
    result = sum(tmp);
    
end

