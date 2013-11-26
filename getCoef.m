function [Di,start,e] = getCoef(C,L, index, level)
    start = L(1);
    count = 1;
    for i=2:(level-index+1)
       start = start+L(i);
       count = i;
    end
    start=start+1;
    count = count+1;
    len = L(count);
    e = start + len - 1;
    
    Di = C(:,start:e);

end
