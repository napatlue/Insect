function result = euclidian_distance( obj1,obj2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    tmp = obj1-obj2;
    tmp = tmp.^2;
    result = sum(tmp);
    
end

