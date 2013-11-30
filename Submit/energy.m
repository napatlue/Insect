function [ ene ] = energy( serie )
%Calculate energy for time serie
    ene = 0;
    for i=1:size(serie,2)
        ene = ene + serie(1,i)^2; 
    end

end

