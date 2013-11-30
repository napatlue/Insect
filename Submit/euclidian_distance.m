function result = euclidian_distance( obj1,obj2 )
% calculate Euclidean distance
    tmp = obj1-obj2;
    tmp = tmp.^2;
    result = sum(tmp);
    
end

