function C = get_class_color( class )
%Get class color for plot
    C = zeros(size(class,1),3);
    for i=1:size(class,1)
        if(class(i)==1)
            C(i,1) = 1;
        elseif(class(i)==2)
            C(i,2) = 1;
        elseif(class(i)==3)
            C(i,3) = 1;
        elseif(class(i)==4)
            C(i,1) = 1;
            C(i,2) = 1;
        elseif(class(i)==5)
            C(i,2) = 1;
            C(i,3) = 1;
        elseif(class(i)==6)
            C(i,1) = 1;
            C(i,3) = 1;
        elseif(class(i)==7)
            C(i,2) = 1;
            C(i,1) = 1;
            C(i,3) = 1;
        elseif(class(i)==8)
            C(i,2) = 0.6;
            C(i,1) = 0.2;
        elseif(class(i)==9)
            C(i,2) = 0.3;
            C(i,3) = 0.7;
        elseif(class(i)==10)
            C(i,2) = 1;
            C(i,1) = 0.5;
        else
            C(i,1) = 0.2;
            C(i,3) = 0.7;
        end
    
    end


end

