function result = cosine_distance( obj1,obj2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    tmp1 = obj1*obj2';
    tmp2 = sqrt((obj1*obj1') * (obj2*obj2'));
    result = 1-(tmp1/tmp2);

end

